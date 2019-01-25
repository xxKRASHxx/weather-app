import Swinject
import ReactiveSwift

class WeatherService: WeatherAPIAccessable, AppStoreAccessable {
  
  static let shared: WeatherService = WeatherService()
  
  private init() {
    setupObserving()
  }
  
  private func setupObserving() {
    store.producer
      .map(\AppState.location.deviceLocation)
      .filterMap { locationStatus -> Location? in
        guard case let .success(location, _) = locationStatus else { return nil }
        return location
      }
      .skipRepeats()
      .observe(on: QueueScheduler.main)
      .startWithValues(weakify(WeatherService.fetchCurrentWeather, object: self))
  }
}

private extension WeatherService {
  func fetchCurrentWeather(in location: Location) {
    store.consume(event: BeginUpdateWeather() )
    weatherAPI.weatherData(for: location).startWithResult { result in
      self.store.consume(event: DidUpdateWeather(
        timeStamp: Date().timeIntervalSince1970,
        result: result.map(Weather.fromDTO)
      ))
    }
  }
}

private extension Weather {
  static func fromDTO(_ forecast: Response.Forecast) -> Weather {
    return Weather(
      location: Weather.Location(
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
