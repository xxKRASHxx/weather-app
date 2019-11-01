// a Swift 3 version of Brandon's implementation: https://gist.github.com/mbrandonw/4acd26ab01bb6140af69

//Helper Protocol
protocol AutoLenses {}

infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

public struct Lens<Whole, Part> {
  let get: (Whole) -> Part
  let set: (Part, Whole) -> Whole
}

public func * <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
  return Lens<A, C>(
    get: { a in rhs.get(lhs.get(a)) },
    set: { (c, a) in lhs.set(rhs.set(c, lhs.get(a)), a) }
  )
}

public func *~ <A, B> (lhs: Lens<A, B>, rhs: B) -> (A) -> A {
  return { a in lhs.set(rhs, a) }
}

public func |> <A, B> (x: A, f: (A) -> B) -> B {
  return f(x)
}

public func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}
// file is prefixed with `z` to display it as a last file in gist BTW

