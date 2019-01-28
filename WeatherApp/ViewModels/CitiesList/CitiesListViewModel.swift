import Foundation
import ReactiveSwift
import Result

protocol CitiesListViewModelProtocol: BaseViewModelProtocol {
  var locations: SignalProducer<[WeatherViewModel], AnyError> { get }
  var openSearch: Action<(), (), NoError> { get }
}

class CitiesListViewModel: BaseViewModel, CitiesListViewModelProtocol {
  
  var locations: SignalProducer<[WeatherViewModel], AnyError> {
    return store.producer
      .map(\AppState.weather.locationsMap)
      .attemptMap { locations in try locations
        .map { (key, value) in (value, self.openWeather(woeid: key) ) }  // <<<<<<<<retain
        .compactMap(WeatherRequestState.makeResult)
    }
  }
  
  var openSearch: Action<(), (), NoError> {
    return Action(weakExecute: weakify(CitiesListViewModel.searchActionProducer, object: self))
  }
  
  fileprivate func openWeather(woeid: AppWeather.WoeID) -> Action<(), (), NoError> {
    return Action(weakExecute: weakify(
      CitiesListViewModel.forecastActionProducer,
      object: self,
      arguments: woeid,
      default: .empty))
  }
}

private typealias ActionsProducers = CitiesListViewModel
private extension ActionsProducers {
  func searchActionProducer() -> SignalProducer<(), NoError> {
    router.perform(route: .search)
    return .empty
  }
  
  func forecastActionProducer(woeid: AppWeather.WoeID) -> () -> SignalProducer<(), NoError> {
    return {
      self.router.perform(route: .forecast(woeid: woeid))
      return .empty
    }
  }
}

private extension WeatherRequestState {
  static func makeResult(
    _ state: WeatherRequestState,
    action: Action<(), (), NoError>)
    throws -> WeatherViewModel? {
      switch state {
      case let .success(current): return WeatherViewModel(weather: current, select: action)
      case let .error(value): throw value
      case .updating, .selected: return nil
      }
  }
}
