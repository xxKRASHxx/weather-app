import SwinjectAutoregistration
import Swinject

private struct FactoryAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(ViewModelFactoryProtocol.self, initializer: ViewModelFactory.init).inObjectScope(.container)
  }
}

private struct RouterAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(ViewModelRouterProtocol.self, initializer: ViewModelRouter.init).inObjectScope(.container)
  }
}

private struct UtilityServicesAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(WeatherAPIServiceProtocol.self, initializer: WeatherAPIService.init).inObjectScope(.container)
  }
}

public let assemblies: [Assembly] = [
//  StorageAssembly(),
  UtilityServicesAssembly(),
//  DomainServicesAssembly(),
  FactoryAssembly(),
  RouterAssembly()
]
