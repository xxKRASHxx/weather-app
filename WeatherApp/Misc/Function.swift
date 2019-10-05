import Foundation

func execute<T> (_ action: () -> T) -> T {
  return action()
}

func id<T>(_ value: T) -> T {
  return value
}

func takeSecond<T, U>(first: T, second: U) -> U {
  return second
}

func takeFirst<T, U>(first: T, second: U) -> T {
  return first
}
