import Swinject
import struct Result.AnyError
import ReactiveSwift

class ViewModelRouter: ViewModelRouterProtocol {
  
  let uiRouteSignal: Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), Never>
  private let uiRouteObserver: Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), Never>.Observer
  private lazy var factory: ViewModelFactoryProtocol = Container.default.resolver.resolve(ViewModelFactoryProtocol.self)!
  
  init() {
    (uiRouteSignal, uiRouteObserver) = Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), Never>.pipe()
  }
  
  func perform(route: RouteType) {
    var viewModel: BaseViewModelProtocol?
    switch route {
    case .root: viewModel = factory.rootViewModel()
    case .permissions: viewModel = factory.permissionsViewModel()
    case .citiesList: viewModel = factory.citiesListViewModel()
    case .search: viewModel = factory.searchViewModel()
    case let .forecast(woeid): viewModel = factory.createForecastViewModel(with: woeid)
    case .dismiss: viewModel = nil
    }
    uiRouteObserver.send(value: (route: route, viewModel: viewModel))
  }
}
