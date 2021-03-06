import WeatherAppCore

protocol ViewModelFactoryProtocol {
  func rootViewModel() -> RootScreenViewModelProtocol
  func permissionsViewModel() -> PermissionsViewModelProtocol
  func citiesListViewModel() -> CitiesListViewModelProtocol
  func searchViewModel() -> SearchViewModelProtocol
  func createForecastViewModel(with woeid: WoeID) -> ForecastViewModelProtocol
}
