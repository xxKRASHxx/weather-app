import ReactiveSwift
import Result

protocol ViewModelRouterProtocol {
  
  var uiRouteSignal: Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), NoError> { get }
  func perform(route: RouteType)
}
