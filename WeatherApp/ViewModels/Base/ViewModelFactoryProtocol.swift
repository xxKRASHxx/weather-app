import UIKit

protocol ViewModelFactoryProtocol {
  
  func rootViewModel() -> RootScreenViewModelProtocol
  func permissionsViewModel() -> PermissionsViewModelProtocol
  func citiesListViewModel() -> CitiesListViewModelProtocol
  func searchViewModel() -> SearchViewModelProtocol
}
