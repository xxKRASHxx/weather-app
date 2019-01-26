import Swinject
import ReactiveSwift
import Result

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
      .filterMap { locationStatus -> Location? in
        guard case let .success(location, _) = locationStatus else { return nil }
        return location
      }
      .skipRepeats()
      .observe(on: QueueScheduler.main)
      .startWithValues(weakify(WeatherService.fetchCurrentWeather, object: self))
  }
  
  @discardableResult private func observeSearching() -> Disposable {
    return store.producer
      .map(\AppState.searching)
      .filterMap { (search) -> String? in
        guard case let .searching(text) = search
          else { return nil }
        return text
      }
      .skipRepeats()
      .throttle(0.3, on: QueueScheduler.main)
      .flatMap(.latest, weatherAPI.search)
      .map { $0.map(SearchResult.fromDTO) }
      .startWithResult { result in
        self.store.consume(event: DidEndSearch(
          timeStamp: Date().timeIntervalSince1970,
          result: result))
    }
  }
  
  @discardableResult private func observeSelectedLocations() -> Disposable {
    
    let unhandled: (([AppWeather.WoeID : WeatherRequestState]) -> [Int]) = { locations in locations
      .filter { (_, value) in value == .selected }
      .compactMap { (key, _) in key.id }
    }
    
    return store.producer
      .map(\AppState.weather.locationsMap)
      .map(unhandled)
      .flatMap(.latest, SignalProducer<Int, NoError>.init)
      .flatMap(.latest, weatherAPI.weatherData)
      .map(Weather.fromDTO)
      .flatMapError { _ in .never }
      .map(fromWeatherResponse)
      .startWithValues(store.consume)
  }
}

private typealias Mapping = WeatherService
private extension Mapping {
  func fromWeatherResponse(_ model: Weather) -> AppEvent {
    return DidUpdateWeather(
      timeStamp: Date().timeIntervalSince1970,
      id: .searched(value: model.location.woeid),
      result: .init(value: model)
    )
  }
}

private extension WeatherService {
  func fetchCurrentWeather(in location: Location) {
    store.consume(event: BeginUpdateWeather(id: .current) )
    weatherAPI.weatherData(for: location)
      .map(Weather.fromDTO)
      .startWithResult { result in
        self.store.consume(event: DidUpdateWeather(
          timeStamp: Date().timeIntervalSince1970,
          id: .current,
          result: result
        ))
    }
  }
}

private extension Weather {
  static func fromDTO(_ forecast: Response.Forecast) -> Weather {
    return Weather(
      location: Weather.Location(
        woeid: forecast.location.woeid,
        city: forecast.location.city,
        country: forecast.location.country,
        coordinates: WeatherApp.Location(
          latitude: forecast.location.lat,
          longitude: forecast.location.long)),
      direction: forecast.current.wind.direction,
      speed: forecast.current.wind.speed,
      text: forecast.current.condition.text,
      temperature: forecast.current.condition.temperature)
  }
}

private extension SearchResult {
  static func fromDTO(_ response: Response.SearchResult) -> SearchResult {
    return SearchResult(
      id: response.woeid,
      location: Location(
        latitude: response.lat,
        longitude: response.lon),
      city: response.city,
      country: response.country,
      qualifiedName: response.qualifiedName)
  }
}
