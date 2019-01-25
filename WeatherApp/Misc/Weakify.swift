public func weakify<Value: AnyObject, Result>(
  _ function: @escaping (Value) -> () -> Result,
  object: Value)
  -> () -> Result? {
    return { [weak object] in
      object.map { function($0)() }
    }
}

public func weakify<Value: AnyObject, Arguments, Result>(
  _ function: @escaping (Value) -> (Arguments) -> Result,
  object: Value,
  default value: Result)
  -> (Arguments) -> Result {
    return { [weak object] arguments in
      object.map { function($0)(arguments) } ?? value
    }
}

public func weakify<Value: AnyObject, Arguments>(
  _ function: @escaping (Value) -> (Arguments) -> Void,
  object: Value)
  -> (Arguments) -> Void {
    return weakify(function, object: object, default: ())
}

public func weakify<Value: AnyObject>(
  _ function: @escaping (Value) -> () -> Void,
  object: Value)
  -> () -> Void {
    return { [weak object] in
      object.map { function($0)() }
    }
}
