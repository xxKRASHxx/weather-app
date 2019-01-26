import Foundation
import ReactiveSwift
import Result

protocol CitiesListViewModelProtocol: BaseViewModelProtocol {
  var locations: SignalProducer<[Weather], AnyError> { get }
  var openSearch: Action<(), (), NoError> { get }
}

class CitiesListViewModel: BaseViewModel, CitiesListViewModelProtocol {
  
  var locations: SignalProducer<[Weather], AnyError> {
    return store.producer
      .map(\AppState.weather.locationsMap)
      .attemptMap { locations in try locations
        .map { (key, value) in value }
        .compactMap(WeatherRequestState.makeResult) }
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
