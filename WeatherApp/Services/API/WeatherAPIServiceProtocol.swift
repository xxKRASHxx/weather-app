import ReactiveSwift
import Result
import Swinject

struct WeatherAPIError<T>: Swift.Error {
  
  public let original: Swift.Error
  public let reason: T
  
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
  func weatherData(for location: Location) -> SignalProducer<Response.Forecast, AnyError>
  func weatherData(for cityWoeid: Int) -> SignalProducer<Response.Forecast, WeatherAPIError<Int>>
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
