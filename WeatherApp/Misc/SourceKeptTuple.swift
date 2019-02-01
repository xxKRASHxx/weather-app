import ReactiveSwift
import Result

typealias SourceKeptTuple<T, U> = (source: T, result: U)
func keepSource<T, U>(_ transform: @escaping (T) -> U) -> (T) -> SourceKeptTuple<T, U> {
  return { source in SourceKeptTuple(source: source, result: transform(source)) }
}

func transformResult<T, U, V>(
  _ transform: @escaping (U) -> V)
  -> (SourceKeptTuple<T, U>) -> SourceKeptTuple<T, V>
{
  return { tuple in SourceKeptTuple(source: tuple.source, result: transform(tuple.result)) }
}

func transformResult<T, U, V, Error>(
  _ transform: @escaping (U) -> SignalProducer<V, Error>,
  _ transformError: @escaping (Error, SourceKeptTuple<T, U>) -> Void)
  -> (SourceKeptTuple<T, U>) -> SignalProducer<(T, V), NoError>
{
  return { tuple -> SignalProducer<(T, V), NoError> in
    return SignalProducer.zip(
      Property(value: tuple.source).producer,
      transform(tuple.result).flatMapError { error in
        transformError(error, tuple)
        return .never
      }
    )
  }
}

func transformResult<T, U, V>(
  _ transform: @escaping (U) -> SignalProducer<V, NoError>)
  -> (SourceKeptTuple<T, U>) -> SignalProducer<(T, V), NoError>
{
  return { tuple -> SignalProducer<(T, V), NoError> in
    return SignalProducer.zip(
      Property(value: tuple.source).producer,
      transform(tuple.result)
    )
  }
}
