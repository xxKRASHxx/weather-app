import Foundation
import ReactiveSwift
import Result

protocol CitiesListViewModelProtocol: BaseViewModelProtocol {
  var locations: SignalProducer<[Weather], AnyError> { get }
  var current: SignalProducer<Weather?, AnyError> { get }
  var openSearch: Action<(), (), NoError> { get }
}

class CitiesListViewModel: BaseViewModel, CitiesListViewModelProtocol {
  
  var locations: SignalProducer<[Weather], AnyError> {
    
    let deviceWeather = current.map { $0.map { [$0] } ?? [] }
    let selectedWeather = store.producer
      .map(\AppState.weather)
      .attemptMap { weather in
        try weather.selectedLocations
          .compactMap { weather.allLocations[$0] }
          .compactMap(WeatherRequestState.makeResult)
      }
    
    return deviceWeather.concat(selectedWeather)
  }
  
  var current: SignalProducer<Weather?, AnyError> {
    return store.producer
      .map(\AppState.weather.currentLocation)
      .attemptMap(WeatherRequestState.makeResult)
  }
  
  var openSearch: Action<(), (), NoError> {
    return Action(weakExecute: weakify(CitiesListViewModel.searchActionProducer, object: self))
  }
}

private typealias Actions = CitiesListViewModel
private extension Actions {
  func searchActionProducer() -> SignalProducer<(), NoError> {
    router.perform(route: .search)
    return .empty
  }
}

private extension WeatherRequestState {
  static func makeResult(_ state: WeatherRequestState) throws -> Weather? {
    switch state {
    case let .success(current): return current
    case let .error(value): throw value
    case .updating, .selected: return nil
    }
  }
}
