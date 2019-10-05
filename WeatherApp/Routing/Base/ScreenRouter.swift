import UIKit
import Swinject
import Hero

class ScreenRouter {
  
  private weak var window: UIWindow?
  private let viewModelRouter: ViewModelRouterProtocol = Container.current.resolve(ViewModelRouterProtocol.self)!
  private let screenFactory: ScreenFactoryProtocol = Container.current.resolve(ScreenFactoryProtocol.self)!
  
  var navigationController: UINavigationController {
    return window!.rootViewController as! UINavigationController
  }
  
  init(window: UIWindow) {
    self.window = window
    let navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.barTintColor = .white
    navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    setupObserving()
  }
  
  func setupObserving() {
    viewModelRouter.uiRouteSignal.observeValues(self.perform)
  }
  
  private func perform(route: (route: RouteType, viewModel: BaseViewModelProtocol?)) {
    switch route.route {
    case .root:
      let controller = screenFactory.createRootScreen()
      controller.connectViewModel(route.viewModel)
      navigationController.setViewControllers([controller], animated: false)
    case .permissions:
      let controller = screenFactory.createPermissionsScreen()
      controller.connectViewModel(route.viewModel)
      navigationController.setViewControllers([controller], animated: false)
    case .citiesList:
      let controller = screenFactory.createCitiesListScreen()
      controller.connectViewModel(route.viewModel)
      navigationController.setViewControllers([controller], animated: false)
    case .search:
      let controller = screenFactory.createSearchScreen()
      controller.connectViewModel(route.viewModel)
      let navigation = UINavigationController(rootViewController: controller)
      navigation.modalPresentationStyle = .overCurrentContext
      navigationController.present(navigation, animated: true)
    case .forecast:
      let controller = screenFactory.createForecastScreen()
      controller.connectViewModel(route.viewModel)
      
      let titleID = UUID().uuidString
      if let source = navigationController.viewControllers.last as? CitiesListScreen {
        source.selectedView?.hero.id = titleID
        source.selectedView?.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
      }
      controller.hero.isEnabled = true
      
      controller.cardView.hero.id = titleID
      controller.cardView.hero.modifiers = [
        .spring(stiffness: 250, damping: 25),
        .source(heroID: titleID),
      ]
      
      controller.tableView.hero.id = titleID
      controller.tableView.hero.modifiers = [
        .spring(stiffness: 250, damping: 25),
        .source(heroID: titleID)
      ]
//      
//      controller.closeButton.hero.modifiers = [
//        .fade,
//        .delay(0.3),
//        .zPosition(1)
//      ]
      controller.hero.modalAnimationType = .selectBy(
        presenting: .none,
        dismissing: .fade
      )
      
      navigationController.present(controller, animated: true)
      
    case .dismiss:
      navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
  }
}
