import Foundation
import WeatherAppShared
import Swinject
import SwinjectAutoregistration

private struct AppFactoryAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(ScreenFactoryProtocol.self, initializer: ScreenFactory.init)
        container.register(Bundle.self,
                           factory: { _ in return Bundle.main })
            .inObjectScope(.container)
    }
}

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

public let appAssemblies: [Assembly] = [
    AppFactoryAssembly(),
    FactoryAssembly(),
    RouterAssembly()
]

extension Container {
  static var `default`: ContainerWrapper = {
    let container = Container()
    appAssemblies.forEach { $0.assemble(container: container) }
    return ContainerWrapper(container: container)
  }()
}
