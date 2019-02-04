import ReactiveSwift
import Result
import Swinject

struct WeatherAPIError<T: Codable & Equatable>: Swift.Error, Codable, Equatable {
  
  struct CannotDecode: Error {}
  
  public let original: Swift.Error
  public let reason: T

  static func == (lhs: WeatherAPIError<T>, rhs: WeatherAPIError<T>) -> Bool {
    return lhs.reason == rhs.reason
      && rhs.original.localizedDescription == lhs.original.localizedDescription
  }
  
  init(from decoder: Decoder) throws {
    self.original = CannotDecode()
    self.reason = try decoder.singleValueContainer().decode(T.self)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(reason)
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
    return Container.current.resolve(WeatherAPIServiceProtocol.self)!
  }
}
