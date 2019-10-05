import Foundation
import UIKit

public struct Reducer<Value> {

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

  public static var or: Reducer {
    return Reducer(empty: false) { $0 || $1 }
  }

  public static var and: Reducer {
    return Reducer(empty: true) { $0 && $1 }
  }
}

extension Reducer where Value == String {

  public static var concat: Reducer {
    return Reducer(empty: "", function: +)
  }

  public static func concat(separator: Character) -> Reducer {
    return Reducer(empty: "") { "\($0)\(separator)\($1)" }
  }
}

extension Reducer where Value == CGFloat {
  public static var concat: Reducer {
    return Reducer(empty: 0, function: +)
  }
}

extension Reducer where Value == UInt {
  public static var concat: Reducer {
    return Reducer(empty: 0, function: +)
  }
}

extension Reducer where Value == Int {

  public static var larger: Reducer {
    return Reducer(empty: .min, function: max)
  }

  public static var lesser: Reducer {
    return Reducer(empty: .max, function: min)
  }
}
