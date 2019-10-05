import Foundation

extension Sequence {
  func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
    return self.map {
      $0[keyPath: keyPath]
    }
  }
  func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
    return self.compactMap {
      $0[keyPath: keyPath]
    }
  }
}

extension Dictionary {
  func mapValues<T>(_ keyPath: KeyPath<Value, T>) -> [Key : T] {
    return self.mapValues {
      $0[keyPath: keyPath]
    }
  }
}
