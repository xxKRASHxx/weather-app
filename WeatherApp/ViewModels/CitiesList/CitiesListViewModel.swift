import Foundation
import ReactiveSwift
import Result

protocol CitiesListViewModelProtocol: BaseViewModelProtocol {
  var title: Property<String> { get }
  var locations: SignalProducer<[WeatherViewModel], AnyError> { get }
  var openSearch: Action<(), (), NoError> { get }
}

class CitiesListViewModel: BaseViewModel, CitiesListViewModelProtocol {
  
  let title = Property(initial: "Forecast", then: .never)
  
  var locations: SignalProducer<[WeatherViewModel], AnyError> {
    let sights = store.producer.map(\AppState.photos.sights)
    let locations = store.producer.map(\AppState.weather.locationsMap)
    return SignalProducer.combineLatest(locations, sights)
      .attemptMap { (arg) -> [WeatherViewModel] in
        let (locations, sights) = arg
        return try locations
          .map { (key, value) in (value, sights[key]?.url, self.isCurrent, self.openWeather(woeid: key) ) }
          .compactMap(WeatherRequestState.makeResult)
          .sorted { (lhs, rhs) in lhs.isCurrent.value }
    }
  }
  
  var openSearch: Action<(), (), NoError> {
    return Action(weakExecute: weakify(CitiesListViewModel.searchActionProducer, object: self))
  }
  
  fileprivate func openWeather(woeid: WoeID) -> Action<(), (), NoError> {
    return Action(weakExecute: weakify(
      CitiesListViewModel.forecastActionProducer,
      object: self,
      arguments: woeid,
      default: .empty))
  }
}

private typealias ActionsProducers = CitiesListViewModel
private extension ActionsProducers {
  
  func isCurrent(_ id: WoeID) -> SignalProducer<Bool, NoError> {
    return store.producer.map(\AppState.weather.current).map { current in id == current }
  }
  
  func searchActionProducer() -> SignalProducer<(), NoError> {
    router.perform(route: .search)
    return .empty
  }
  
  func forecastActionProducer(woeid: WoeID) -> () -> SignalProducer<(), NoError> {
    return {
      self.router.perform(route: .forecast(woeid: woeid))
      return .empty
    }
  }
}

private extension WeatherRequestState {
  static func makeResult(
    _ state: WeatherRequestState,
    url: URL?,
    isCurrent: (WoeID) -> SignalProducer<Bool, NoError>,
    action: Action<(), (), NoError>)
    throws -> WeatherViewModel? {
      switch state {
      case let .success(current): return WeatherViewModel(
        weather: current,
        photo: url,
        isCurrent: Property(initial: false, then: isCurrent(current.location.woeid)),
        select: action)
      case let .error(value): throw value
      case .updating, .selected: return nil
      }
  }
}
