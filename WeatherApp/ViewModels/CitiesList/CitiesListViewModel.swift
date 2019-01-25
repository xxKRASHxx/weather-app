import Foundation
import ReactiveSwift
import Result


protocol CitiesListViewModelProtocol {
  var current: SignalProducer<Weather?, AnyError> { get }
}

class CitiesListViewModel: BaseViewModel, CitiesListViewModelProtocol {
  var current: SignalProducer<Weather?, AnyError> {
    return store.producer
      .map(\AppState.weather.currentLocation)
      .attemptMap { state in
        switch state {
        case let .success(current): return current
        case let .error(value): throw value
        case .updating, .none: return nil
        }
      }
  }
}
