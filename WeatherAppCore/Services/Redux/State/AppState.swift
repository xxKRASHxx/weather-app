import Foundation
import Redux_ReactiveSwift

public struct AppState: Encodable {
  public let location: AppLocation
  public let weather: AppWeather
  public let searching: AppSearch
  public let sync: AppSync
  public let photos: AppPhotos
}

extension AppState: Defaultable {
  public static var defaultValue = AppState(
    location: .defaultValue,
    weather: .defaultValue,
    searching: .defaultValue,
    sync: .defaultValue,
    photos: .defaultValue)
}

extension AppState {
  static func reudce(_ state: AppState, _ event: AppEvent) -> AppState {
    return AppState(
      location: AppLocation.reudce(state.location, event),
      weather: AppWeather.reudce(state.weather, event),
      searching: AppSearch.reudce(state.searching, event),
      sync: AppSync.reduce(state.sync, event),
      photos: AppPhotos.reduce(state.photos, event)
    )
  }
  
  static func trottleLocationUpdates(_ state: AppState, _ event: AppEvent) -> AppState {
    return AppState(
      location: AppLocation.trottleLocationUpdates(state.location, event),
      weather: state.weather,
      searching: state.searching,
      sync: state.sync,
      photos: state.photos
    )
  }
}
