import Swinject

protocol BaseViewModelProtocol {
  var router: ViewModelRouterProtocol { get }
}

class BaseViewModel: AppStoreAccessable, BaseViewModelProtocol {
  
  let router: ViewModelRouterProtocol = Container.current.resolve(ViewModelRouterProtocol.self)!
  
  required init() {}
}
