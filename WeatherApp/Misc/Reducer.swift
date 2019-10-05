import Foundation
import UIKit

struct Reducer<Value> {

  public typealias ValueType = Value
  public typealias FunctionType = (Value, Value) -> Value

  public var empty: ValueType
  public var function: FunctionType

  public init(empty: ValueType, function: @escaping FunctionType) {
    self.empty = empty
    self.function = function
  }
}

extension Reducer where Value == Bool {

  static var or: Reducer {
    return Reducer(empty: false) { $0 || $1 }
  }

  static var and: Reducer {
    return Reducer(empty: true) { $0 && $1 }
  }
}

extension Reducer where Value == String {

  static var concat: Reducer {
    return Reducer(empty: "", function: +)
  }

  static func concat(separator: Character) -> Reducer {
    return Reducer(empty: "") { "\($0)\(separator)\($1)" }
  }
}

extension Reducer where Value == CGFloat {
  static var concat: Reducer {
    return Reducer(empty: 0, function: +)
  }
}

extension Reducer where Value == UInt {
  static var concat: Reducer {
    return Reducer(empty: 0, function: +)
  }
}

extension Reducer where Value == Int {

  static var larger: Reducer {
    return Reducer(empty: .min, function: max)
  }

  static var lesser: Reducer {
    return Reducer(empty: .max, function: min)
  }
}
