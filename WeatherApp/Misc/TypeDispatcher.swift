@discardableResult public func cast<From, To>(_ value: From?, targetType: To.Type? = nil, onSuccess: ((To) -> Void)? = nil) -> To? {
  guard let value = value as? To else { return nil }
  onSuccess.map { $0(value) }
  return value
}

public func failableCast<From, To>(_ value: From?, targetType: To.Type? = nil) -> To {
  guard let casted = value as? To else { fatalError("Casting \(String(describing: value)) to \(String(describing: targetType)) failed") }
  return casted
}

enum TypeDispatcher<ValueType> {
  case value(ValueType)
  
  @discardableResult func dispatch<Subject>(_ closure: (Subject) -> Void) -> TypeDispatcher<ValueType> {
    switch self {
    case .value(let value):
      cast(value).map(closure)
      return .value(value)
    }
  }
  
  func extract() -> ValueType {
    switch self {
    case .value(let value):
      return value
    }
  }
}
