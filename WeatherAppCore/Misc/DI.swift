import SwinjectAutoregistration
import Swinject
import WeatherAppShared

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
  StorageServicesAssembly()
]

extension Container {
  static var `default`: ContainerWrapper = {
    let container = Container()
    assemblies.forEach { $0.assemble(container: container) }
    return ContainerWrapper(container: container)
  }()
}
