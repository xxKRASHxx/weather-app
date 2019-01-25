import UIKit
import Swinject

class ScreenRouter {
  
  private weak var window: UIWindow?
  private let viewModelRouter: ViewModelRouterProtocol = Container.current.resolve(ViewModelRouterProtocol.self)!
  private let screenFactory: ScreenFactoryProtocol = Container.current.resolve(ScreenFactoryProtocol.self)!
  
  init(window: UIWindow) {
    self.window = window
    window.rootViewController = UINavigationController()
    window.makeKeyAndVisible()
    setupObserving()
  }
  
  func setupObserving() {
    viewModelRouter.uiRouteSignal.observeValues(self.perform)
  }
  
  private func perform(route: (route: RouteType, viewModel: BaseViewModel?)) {
    switch route.route {
    case .root:
      TypeDispatcher.value(window?.rootViewController)
        .dispatch { (navigation: UINavigationController) in
          let controller = screenFactory.createRootScreen()
          controller.connectViewModel(route.viewModel)
          navigation.setViewControllers([controller], animated: false)
        }
    case .permissions:
      TypeDispatcher.value(window?.rootViewController)
        .dispatch { (navigation: UINavigationController) in
          let controller = screenFactory.createPermissionsScreen()
          controller.connectViewModel(route.viewModel)
          navigation.setViewControllers([controller], animated: false)
      }
    case .citiesList:
      TypeDispatcher.value(window?.rootViewController)
        .dispatch { (navigation: UINavigationController) in
          let controller = screenFactory.createCitiesListScreen()
          controller.connectViewModel(route.viewModel)
          navigation.setViewControllers([controller], animated: false)
      }
    }
  }
}
