import Swinject

class BaseViewModel: AppStoreAccessable {
  
  let router: ViewModelRouterProtocol = Container.current.resolve(ViewModelRouterProtocol.self)!
  
  required init() {}
}
