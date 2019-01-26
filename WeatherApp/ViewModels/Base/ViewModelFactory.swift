class ViewModelFactory: ViewModelFactoryProtocol {
  
  func rootViewModel() -> RootScreenViewModelProtocol {
    return RootScreenViewModel()
  }
  
  func permissionsViewModel() -> PermissionsViewModelProtocol {
    return PermissionsViewModel()
  }
  
  func citiesListViewModel() -> CitiesListViewModelProtocol {
    return CitiesListViewModel()
  }
  
  func searchViewModel() -> SearchViewModelProtocol {
    return SearchViewModel()
  }
}

