import Foundation

open class Mixin<Base> {
  public var base: Base
  
  public init(constructor: () -> Base) {
    base = constructor()
  }
}

open class NSMixin<Base>: NSObject {
  public let base: Base
  
  public init(constructor: () -> Base) {
    base = constructor()
  }
}
