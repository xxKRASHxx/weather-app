import UIKit
import Swinject

class ScreenFactory: ScreenFactoryProtocol {

  private lazy var factory: ViewModelFactoryProtocol = Container.default.resolver.resolve(ViewModelFactoryProtocol.self)!
  
  func createRootScreen() -> RootScreen {
    return RootScreen()
  }
  
  func createPermissionsScreen() -> PermissionsScreen {
    return PermissionsScreen()
  }
  
  func createCitiesListScreen() -> CitiesListScreen {
    return CitiesListScreen()
  }
  
  func createSearchScreen() -> SearchScreen {
    return SearchScreen()
  }
  
  func createForecastScreen() -> ForecastScreen {
    return ForecastScreen()
  }
}
