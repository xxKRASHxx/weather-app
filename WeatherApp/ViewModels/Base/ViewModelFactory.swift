class ViewModelFactory: ViewModelFactoryProtocol {
  
  func rootViewModel() -> RootScreenViewModel {
    return RootScreenViewModel()
  }
  
  func permissionsViewModel() -> PermissionsViewModel {
    return PermissionsViewModel()
  }
  
  func citiesListViewModel() -> CitiesListViewModel {
    return CitiesListViewModel()
  }
}

