import Foundation

class Mixin<Base> {
  var base: Base
  
  init(constructor: () -> Base) {
    base = constructor()
  }
}

public class NSMixin<Base>: NSObject {
  let base: Base
  
  init(constructor: () -> Base) {
    base = constructor()
  }
}
