import Swinject
import ReactiveSwift
import struct Result.AnyError
import WeatherAppShared

class WeatherService: WeatherAPIAccessable, AppStoreAccessable {
  
  static let shared: WeatherService = WeatherService()
  
  private init() {
    setupObserving()
  }
  
  private func setupObserving() {
    observeCurrentWeather()
    observeSearching()
    observeSelectedLocations()
  }
  
  @discardableResult private func observeCurrentWeather() -> Disposable {
    return store.producer
      .map(\AppState.location.deviceLocation)
      .filterMap { $0.location }
      .skipRepeats()
      .startWithValues(fetchCurrentWeather)
  }
  
  @discardableResult private func observeSearching() -> Disposable {
    
    let searchingText: (AppSearch) -> String? = { state in
      guard case let .searching(text) = state
        else { return nil }
      return text
    }
    
    return store.producer
      .map(\AppState.searching)
      .filterMap(searchingText)
      .skipRepeats()
      .throttle(0.5, on: QueueScheduler.main)
      .flatMap(.latest, weatherAPI.search)
      .map { $0.map(SearchResult.fromDTO) }
      .startWithResult(consumeSearchResult)
  }
  
  @discardableResult private func observeSelectedLocations() -> Disposable {
    
    let compositeDisposable = CompositeDisposable()
    
    let unhandled: (([WoeID : WeatherRequestState]) -> [WoeID]) = { locations in locations
      .filter { (_, value) in value == .selected }
      .compactMap(takeFirst)
    }
    
    let woeidProducer = store.producer
      .map(\AppState.weather.locationsMap)
      .map(unhandled)
      .skipRepeats()
    
    woeidProducer
      .map(BeginUpdateWeather.init)
      .startWithValues(store.consume)
    
    woeidProducer
      .flatMap(.latest, SignalProducer<WoeID, Never>.init)
      .flatMap(.merge, weatherAPI.weatherData)
      .map(Weather.fromDTO)
      .map(fromWeatherResponse)
      .flatMapError(fromWeatherError)
      .startWithValues(store.consume)

    return compositeDisposable
  }
}

private typealias Mapping = WeatherService
private extension Mapping {
  func fromWeatherResponse(_ model: Weather) -> AppEvent {
    return DidUpdateWeather(
      timeStamp: Date().timeIntervalSince1970,
      result: .init(value: model)
    )
  }
  
  func fromWeatherError(_ error: WeatherAPIError<WoeID>) -> SignalProducer<AppEvent, Never> {
    return SignalProducer(value: DidUpdateWeather(
      timeStamp: Date().timeIntervalSince1970,
      result: .init(error: error)))
  }
}

private extension WeatherService {
  
  func fetchCurrentWeather(in location: Coordinates2D) {
    store.consume(event: BeginUpdateCurrentWeather())
    weatherAPI.weatherData(for: location)
      .map(Weather.fromDTO)
      .startWithResult(consumeCurrentWeather)
  }
  
  func consumeCurrentWeather(_ result: Result<Weather, WeatherAPIError<WoeID>>) {
    store.consume(event: DidUpdateCurrentWeather(
      timeStamp: Date().timeIntervalSince1970,
      result: result
    ))
  }
  
  func consumeSearchResult(_ result: Result<[SearchResult], AnyError>) {
    store.consume(event: DidEndSearch(
      timeStamp: Date().timeIntervalSince1970,
      result: result))
  }
}

private extension Weather {
  static func fromDTO(_ forecast: Response.Weather) -> Weather {
    
    func fromDTO(forecast: Response.Weather.Forecast) -> Weather.Forecast {
      return .init(
        date: forecast.date,
        low: forecast.low,
        high: forecast.high,
        text: forecast.text)
    }
    
    func fromDTO(current: Response.Weather.Main) -> Weather.Now {
      return Weather.Now(
        wind: Weather.Now.Wind(
          chill: current.wind.chill,
          direction: current.wind.direction,
          speed: current.wind.speed),
        condition: Weather.Now.Condition(
          text: current.condition.text,
          temperature: .init(
            value: current.condition.temperature,
            unit: .celsius)),
        atmosphere: Weather.Now.Atmosphere(
          visibility: current.atmosphere.visibility,
          pressure: current.atmosphere.pressure),
        astronomy: Weather.Now.Astronomy(
          sunrise: current.astronomy.sunrise,
          sunset: current.astronomy.sunset))
    }
    
    return Weather(
      location: Weather.Location(
        woeid: WoeID(value: forecast.location.woeid),
        city: forecast.location.city,
        country: forecast.location.country,
        coordinates: WeatherAppCore.Coordinates2D(
          latitude: forecast.location.lat,
          longitude: forecast.location.long)),
      forecasts: forecast.forecasts.map(fromDTO),
      now: fromDTO(current: forecast.current))
  }
}

private extension SearchResult {
  static func fromDTO(_ response: Response.SearchResult) -> SearchResult {
    return SearchResult(
      id: response.woeid,
      location: Coordinates2D(
        latitude: response.lat,
        longitude: response.lon),
      city: response.city,
      country: response.country,
      qualifiedName: response.qualifiedName)
  }
}
