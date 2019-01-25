import Swinject
import Result
import ReactiveSwift

class ViewModelRouter: ViewModelRouterProtocol {
  
  let uiRouteSignal: Signal<(route: RouteType, viewModel: BaseViewModel?), NoError>
  private let uiRouteObserver: Signal<(route: RouteType, viewModel: BaseViewModel?), NoError>.Observer
  private lazy var factory: ViewModelFactoryProtocol = Container.current.resolve(ViewModelFactoryProtocol.self)!
  
  init() {
    (uiRouteSignal, uiRouteObserver) = Signal<(route: RouteType, viewModel: BaseViewModel?), NoError>.pipe()
  }
  
  func perform(route: RouteType) {
    var viewModel: BaseViewModel!
    switch route {
    case .root: viewModel = factory.rootViewModel()
    case .permissions: viewModel = factory.permissionsViewModel()
    case .citiesList: viewModel = factory.citiesListViewModel()
    }
    uiRouteObserver.send(value: (route: route, viewModel: viewModel))
  }
}
