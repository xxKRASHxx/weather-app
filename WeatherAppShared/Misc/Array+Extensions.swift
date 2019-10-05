extension Array {

  public func join(_ reducer: Reducer<Element>) -> Element {
    return self.reduce(reducer.empty, reducer.function)
  }

  public func apply<Value, Result>(_ value: Value) -> [Result]
    where Element == (Value) -> Result {
      return self.map { $0(value) }
  }

  @discardableResult
  public func apply<T, U>(_ arguments: [T]) -> [U]
    where Element == (T) -> U {
      return zip(self, arguments).map { $0($1) }
  }
}

extension Collection {
  public func on(_ body: (Self.Element) throws -> Void) rethrows -> Self {
    try self.forEach(body)
    return self
  }
}

extension Array {
  public var second: Element? {
    guard indices.contains(1) else { return nil }
    return self[1]
  }
  
  public var third: Element? {
    guard indices.contains(2) else { return nil }
    return self[2]
  }
}
