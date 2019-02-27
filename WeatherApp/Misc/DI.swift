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

private struct APIServicesAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(PhotosAPIServiceProtocol.self, initializer: PhotosAPIService.init).inObjectScope(.container)
    container.autoregister(WeatherAPIServiceProtocol.self, initializer: WeatherAPIService.init).inObjectScope(.container)
    container.autoregister(MQTTServiceProtocol.self, initializer: MQTTService.init).inObjectScope(.container)
  }
}

private struct StorageServicesAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(UserDefaultsStorageProtocol.self, initializer: UserDefaultsStorage.init).inObjectScope(.container)
  }
}

public let assemblies: [Assembly] = [
  APIServicesAssembly(),
  StorageServicesAssembly(),
  FactoryAssembly(),
  RouterAssembly()
]
