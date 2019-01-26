import UIKit

protocol ScreenFactoryProtocol {
  
  func createRootScreen() -> RootScreen
  func createPermissionsScreen() -> PermissionsScreen
  func createCitiesListScreen() -> CitiesListScreen
  func createSearchScreen() -> SearchScreen
}
