import Result
import ReactiveSwift
import Moya

fileprivate extension WeatherAPIService {
  
  enum BaseURL {
    static let weatherAPI = URL(string: "https://weather-ydn-yql.media.yahoo.com")!
    static let searchAPI = URL(string: "https://www.yahoo.com")!
  }
  
  enum Request {
    case byCoordinates(lat: Double, lon: Double)
    case byWoeid(id: Int)
    case searchCity(named: String)
  }
}

class WeatherAPIService: WeatherAPIServiceProtocol {

  private let authPlugin = AuthPlugin(credentials: .init(
    key: "***REMOVED***",
    secret: "***REMOVED***"))
  
  fileprivate lazy var provider = MoyaProvider<Request>(plugins: [self.authPlugin])
}

extension WeatherAPIService {
  func weatherData(for cityWoeid: Int) -> SignalProducer<Response.Forecast, WeatherAPIError<Int>> {
    return SignalProducer { observer, lifetime in
      lifetime += self.provider.reactive.request(
        .byWoeid(id: cityWoeid))
        .start { [weak self] event in
          defer { observer.sendCompleted() }
          switch event {
          case let .value(response):
            do { observer.send(value: try response.map(Response.Forecast.self)) }
            catch { observer.send(error: WeatherAPIError(error, reason: cityWoeid)) }
          case let .failed(error):
            observer.send(error: WeatherAPIError(error, reason: cityWoeid))
          default: break
          }
      }
    }
  }
  
  func weatherData(for location: Location) -> SignalProducer<Response.Forecast, AnyError> {
    return SignalProducer { observer, lifetime in
      lifetime += self.provider.reactive.request(
        .byCoordinates(lat: location.latitude, lon: location.longitude))
        .start { [weak self] event in
          defer { observer.sendCompleted() }
          switch event {
          case let .value(response):
            do { observer.send(value: try response.map(Response.Forecast.self)) }
            catch { observer.send(error: AnyError(error)) }
          case let .failed(error):
            observer.send(error: AnyError(error))
          default: break
          }
      }
    }
  }
  
  func search(city named: String) -> SignalProducer<[Response.SearchResult], AnyError> {
    return SignalProducer { observer, lifetime in
      lifetime += self.provider.reactive.request(
        .searchCity(named: named))
        .start{ [weak self] event in
          defer { observer.sendCompleted() }
          switch event {
          case let .value(response):
            do { observer.send(value: try response.map([Response.SearchResult].self)) }
            catch { observer.send(error: AnyError(error)) }
          case let .failed(error):
            observer.send(error: AnyError(error))
          default: break
          }
        }
    }
  }
}

extension WeatherAPIService.Request: TargetType {
  
  var baseURL: URL {
    switch self {
    case .byCoordinates, .byWoeid: return WeatherAPIService.BaseURL.weatherAPI
    case .searchCity: return WeatherAPIService.BaseURL.searchAPI
    }
  }
  
  var path: String {
    switch self {
    case .byCoordinates, .byWoeid: return "forecastrss"
    case .searchCity: return "news/_tdnews/api/resource/WeatherSearch"
    }
  }
  
  var method: Moya.Method { return .get }
  
  var sampleData: Data { return Data() }
  
  var task: Task {
    switch self {
    case let .byWoeid(id):
      return .requestParameters(
        parameters: [
          "woeid": id,
          "format": "json",
          "u": "c"
        ],
        encoding: URLEncoding.queryString)
    case let .byCoordinates(lat, lon):
      return .requestParameters(
        parameters: [
          "lat": lat,
          "lon": lon,
          "format": "json",
          "u": "c"
        ],
        encoding: URLEncoding.queryString)
    case let .searchCity(named):
      return .requestParameters(
        parameters: [
          "text": named
        ],
        encoding: URLEncoding.customQueryString
      )
    }
  }
  
  var validationType: ValidationType { return .successCodes }
  
  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}
