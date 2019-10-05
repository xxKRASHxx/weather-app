import Swinject
import Result
import ReactiveSwift

class ViewModelRouter: ViewModelRouterProtocol {
  
  let uiRouteSignal: Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), NoError>
  private let uiRouteObserver: Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), NoError>.Observer
  private lazy var factory: ViewModelFactoryProtocol = Container.current.resolve(ViewModelFactoryProtocol.self)!
  
  init() {
    (uiRouteSignal, uiRouteObserver) = Signal<(route: RouteType, viewModel: BaseViewModelProtocol?), NoError>.pipe()
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
