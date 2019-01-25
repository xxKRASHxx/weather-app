import Foundation
import Redux_ReactiveSwift

struct AppState: Encodable {
  let location: AppLocation
  let weather: AppWeather
}

extension AppState: Defaultable {
  static var defaultValue = AppState(
    location: .defaultValue,
    weather: .defaultValue)
}

extension AppState {
  static func reudce(_ state: AppState, _ event: AppEvent) -> AppState {
    return AppState(
      location: AppLocation.reudce(state.location, event),
      weather: AppWeather.reudce(state.weather, event)
    )
  }
  
  static func trottleLocationUpdates(_ state: AppState, _ event: AppEvent) -> AppState {
    return AppState(
      location: AppLocation.trottleLocationUpdates(state.location, event),
      weather: state.weather
    )
  }
}
