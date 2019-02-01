import Foundation

func execute<T> (_ action: () -> T) -> T {
  return action()
}

func id<T>(_ value: T) -> T {
  return value
}

func new<T>(current: T, new: T) -> T {
  return new
}

func current<T>(current: T, new: T) -> T {
  return current
}
