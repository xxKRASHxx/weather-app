import ReactiveSwift
import struct Result.AnyError
import Swinject

public struct WeatherAPIError<T: Codable & Equatable>: Swift.Error, Codable, Equatable {
  
  public struct CannotDecode: Error {}
  
  public let original: Swift.Error
  public let reason: T

  public static func == (lhs: WeatherAPIError<T>, rhs: WeatherAPIError<T>) -> Bool {
    return lhs.reason == rhs.reason
      && rhs.original.localizedDescription == lhs.original.localizedDescription
  }
  
  public init(from decoder: Decoder) throws {
    self.original = CannotDecode()
    self.reason = try decoder.singleValueContainer().decode(T.self)
  }
  
  public func encode(to encoder: Encoder) throws {
    try reason.encode(to: encoder)
  }
  
  public init(_ error: Swift.Error, reason: T) {
    if let apiError = error as? WeatherAPIError<T> {
      self = apiError
    } else {
      self.original = error
      self.reason = reason
    }
  }
}

protocol WeatherAPIServiceProtocol {
  func weatherData(for location: Coordinates2D) -> SignalProducer<Response.Weather, WeatherAPIError<WoeID>>
  func weatherData(for cityWoeid: WoeID) -> SignalProducer<Response.Weather, WeatherAPIError<WoeID>>
  func search(city named: String) -> SignalProducer<[Response.SearchResult], AnyError>
}

protocol WeatherAPIAccessable {
  var weatherAPI : WeatherAPIServiceProtocol { get }
}

extension WeatherAPIAccessable {
  var weatherAPI : WeatherAPIServiceProtocol {
    return Container.default.resolver.resolve(WeatherAPIServiceProtocol.self)!
  }
}
