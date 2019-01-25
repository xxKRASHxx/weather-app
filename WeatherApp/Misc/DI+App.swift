import Foundation
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

public let appAssemblies: [Assembly] = [
    AppFactoryAssembly()
]
