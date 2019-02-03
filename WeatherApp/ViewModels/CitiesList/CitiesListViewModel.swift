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
    
//    let smth: (
//      _ locations: [WoeID : WeatherRequestState],
//      _ sights: [WoeID : AppPhotos.Status])
//      throws -> [WeatherViewModel]
//      = weakify_throws(CitiesListViewModel.makeWeatherViewModel, object: self, default: [WeatherViewModel]())
//
    
    return SignalProducer.combineLatest(locations, sights)
      .attemptMap(makeWeatherViewModel)
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

private typealias Mapping = CitiesListViewModel
private extension Mapping {
  func makeWeatherViewModel(
    locations: [WoeID : WeatherRequestState],
    sights: [WoeID : AppPhotos.Status])
    throws -> [WeatherViewModel] {
      return try locations
        .compactMap { [weak self] (key, value) in
          guard let `self` = self else { return nil }
          return (value, sights[key]?.url, self.isCurrent(key), self.openWeather(woeid: key) )
        }
        .compactMap(WeatherRequestState.makeResult)
        .sorted { (lhs, rhs) in lhs.isCurrent.value }
  }
}
private extension WeatherRequestState {
  static func makeResult(
    _ state: WeatherRequestState,
    url: URL?,
    isCurrent: SignalProducer<Bool, NoError>,
    action: Action<(), (), NoError>)
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
