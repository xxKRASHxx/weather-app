enum WoeID: AutoCodable, Equatable, Hashable {
  case current
  case searched(value: Int)
  
  var id: Int? {
    guard case let .searched(id) = self else { return nil }
    return id
  }
}
