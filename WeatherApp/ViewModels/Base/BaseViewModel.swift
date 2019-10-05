import Swinject
import WeatherAppCore

protocol BaseViewModelProtocol {
  var router: ViewModelRouterProtocol { get }
}

class BaseViewModel: AppStoreAccessable, BaseViewModelProtocol {
  
  let router: ViewModelRouterProtocol = Container.default.resolver.resolve(ViewModelRouterProtocol.self)!
  
  required init() {}
}
