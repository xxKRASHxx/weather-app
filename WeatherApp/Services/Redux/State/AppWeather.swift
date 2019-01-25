import Redux_ReactiveSwift
import Result

struct AppWeather: Encodable, Equatable {
  let currentLocation: WeatherRequestState
}

enum WeatherRequestState: AutoEncodable, Equatable {
  case none
  case updating
  case success(current: Weather)
  case error(value: AnyError)
}

extension AppWeather: Defaultable {
  static var defaultValue = AppWeather(
    currentLocation: .none)
}

extension AppWeather {
  static func reudce(_ state: AppWeather, _ event: AppEvent) -> AppWeather {
    switch event {
    case is BeginUpdateWeather:
      return AppWeather(currentLocation: .updating)
    case let event as DidUpdateWeather:
      return AppWeather(currentLocation: event.result.analysis(
        ifSuccess: { .success(current: $0) },
        ifFailure: { .error(value: $0) }))
    default: return state
    }
  }
}
