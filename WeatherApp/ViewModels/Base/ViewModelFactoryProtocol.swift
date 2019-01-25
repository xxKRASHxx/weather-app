import UIKit

protocol ViewModelFactoryProtocol {
  
  func rootViewModel() -> RootScreenViewModel
  func permissionsViewModel() -> PermissionsViewModel
  func citiesListViewModel() -> CitiesListViewModel
}
