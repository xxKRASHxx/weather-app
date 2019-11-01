import Foundation

extension Set {
  public func inserting(_ element: Element) -> Self {
    var result = self
    result.insert(element)
    return result
  }
  
  public func removing(_ element: Element) -> Self {
    var result = self
    result.remove(element)
    return result
  }
}

extension Dictionary {
  public func appending(_ key: Key, _ value: Value?) -> [Key: Value] {
    var result = self
    result[key] = value
    return result
  }
}
