import ReactiveSwift
import struct Result.AnyError

protocol ViewModelRouterProtocol {
  
  var uiRouteSignal: Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), Never> { get }
  func perform(route: RouteType)
}
