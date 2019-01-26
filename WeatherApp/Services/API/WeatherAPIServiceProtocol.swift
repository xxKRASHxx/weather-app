import ReactiveSwift
import Result
import Swinject

protocol WeatherAPIServiceProtocol {
  func weatherData(for location: Location) -> SignalProducer<Response.Forecast, AnyError>
  func weatherData(for cityWoeid: Int) -> SignalProducer<Response.Forecast, AnyError>
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
