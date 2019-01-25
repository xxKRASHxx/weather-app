import ReactiveSwift
import Result

protocol ViewModelRouterProtocol {
  
  var uiRouteSignal: Signal<(route: RouteType, viewModel: BaseViewModel?), NoError> { get }
  func perform(route: RouteType)
}
