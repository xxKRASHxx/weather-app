import Foundation
import ReactiveSwift
import struct Result.AnyError

protocol CitiesListViewModelProtocol: BaseViewModelProtocol {
  var title: Property<String> { get }
  var locations: SignalProducer<[WeatherViewModel], AnyError> { get }
  var openSearch: Action<(), (), Never> { get }
}

class CitiesListViewModel: BaseViewModel, CitiesListViewModelProtocol {
  
  let title = Property(initial: "Forecast", then: .never)
  
  var locations: SignalProducer<[WeatherViewModel], AnyError> {
    let sights = store.producer.map(\AppState.photos.sights).skipRepeats()
    let locations = store.producer.map(\AppState.weather.locationsMap).skipRepeats()
    return SignalProducer
      .combineLatest(locations, sights)
      .attemptMap(weakify(CitiesListViewModel.makeWeatherViewModel, object: self, default: []))
      .mapError(AnyError.init)
  }
  
  var openSearch: Action<(), (), Never> {
    return Action(weakExecute: weakify(CitiesListViewModel.searchActionProducer, object: self))
  }
  
  fileprivate func openWeather(woeid: WoeID) -> Action<(), (), Never> {
    return Action(weakExecute: weakify(
      CitiesListViewModel.forecastActionProducer,
      object: self,
      arguments: woeid,
      default: .empty))
  }
}

private typealias ActionsProducers = CitiesListViewModel
private extension ActionsProducers {
  
  func isCurrent(_ id: WoeID) -> SignalProducer<Bool, Never> {
    return store.producer
      .map(\AppState.weather.current)
      .map { current in id == current }
  }
  
  func searchActionProducer() -> SignalProducer<(), Never> {
    router.perform(route: .search)
    return .empty
  }
  
  func forecastActionProducer(woeid: WoeID) -> () -> SignalProducer<(), Never> {
    return {
      self.router.perform(route: .forecast(woeid: woeid))
      return .empty
    }
  }
}

fileprivate extension CitiesListViewModel {
  func makeWeatherViewModel(tuple: (
    locations: [WoeID : WeatherRequestState],
    sights: [WoeID : AppPhotos.Status]))
    throws -> [WeatherViewModel] {
      return try tuple.locations
        .compactMap { (key, value) in
          (value, tuple.sights[key]?.url, self.isCurrent(key), self.openWeather(woeid: key) )
      }
      .compactMap(WeatherRequestState.makeResult)
      .sorted { (lhs, rhs) in lhs.isCurrent.value }
  }
}

private extension WeatherRequestState {
  static func makeResult(
    _ state: WeatherRequestState,
    url: URL?,
    isCurrent: SignalProducer<Bool, Never>,
    action: Action<(), (), Never>)
    throws -> WeatherViewModel? {
      switch state {
      case let .success(current): return WeatherViewModel(
        weather: current,
        photo: url,
        isCurrent: Property(initial: false, then: isCurrent),
        select: action)
      case let .error(value): throw value
      case .updating, .selected: return nil
      }
  }
}
