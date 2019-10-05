import Swinject

public struct ContainerWrapper {
    let registrar: Container
    public let resolver: Resolver
    public init(container: Container) {
        registrar = container
        resolver = container.synchronize()
    }
}

//extension Container {
//  static var `default`: ContainerWrapper = {
//    let container = Container()
//    assemblies.forEach { $0.assemble(container: container) }
//    return ContainerWrapper(container: container)
//  }()
//}
