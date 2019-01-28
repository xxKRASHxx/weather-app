import UIKit

protocol ViewModelFactoryProtocol {
  func rootViewModel() -> RootScreenViewModelProtocol
  func permissionsViewModel() -> PermissionsViewModelProtocol
  func citiesListViewModel() -> CitiesListViewModelProtocol
  func searchViewModel() -> SearchViewModelProtocol
  func createForecastViewModel(with woeid: AppWeather.WoeID) -> ForecastViewModelProtocol
}
