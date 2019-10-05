import Foundation

public func execute<T> (_ action: () -> T) -> T {
  return action()
}

public func id<T>(_ value: T) -> T {
  return value
}

public func takeSecond<T, U>(first: T, second: U) -> U {
  return second
}

public func takeFirst<T, U>(first: T, second: U) -> T {
  return first
}
