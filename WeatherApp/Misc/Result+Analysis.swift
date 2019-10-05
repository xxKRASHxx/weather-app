import Foundation

extension Result {
  func analysis<Result>(
    ifSuccess: (Value) -> Result,
    ifFailure: (Error) -> Result)
    -> Result {
    switch self {
    case let .success(value): return ifSuccess(value)
    case let .failure(error): return ifFailure(error)
    }
  }

  func map<T>(_ keyPath: KeyPath<Value, T>) -> Result<T, Error> {
    return self.map {
      $0[keyPath: keyPath]
    }
  }
}

extension Result {
  var value: Result.Value? {
    switch self {
    case let .success(value): return value
    case .failure: return nil
    }
  }
}

extension Result {
  init(value: Result.Value) {
    self = .success(value)
  }
}
