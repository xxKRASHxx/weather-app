import Swinject

extension Container: Equatable {
  public static func == (lhs: Container, rhs: Container) -> Bool {
    return unsafeBitCast(lhs, to: UInt64.self) == unsafeBitCast(rhs, to: UInt64.self)
  }
}

extension Container {

  private static var containerChain: [Container] = [Assembler.shared.resolver as! Container]
  fileprivate static func push(container: Container) {
    containerChain.append(container)
  }

  fileprivate static func pop(container: Container) {
    if let index = containerChain.firstIndex(of: container) {
      containerChain.remove(at: index)
    }
  }
  static var current: Container {
    return containerChain.last!
  }
}

extension Assembler: Equatable {
  public static func == (lhs: Assembler, rhs: Assembler) -> Bool {
    return unsafeBitCast(lhs, to: UInt64.self) == unsafeBitCast(rhs, to: UInt64.self)
  }
}

