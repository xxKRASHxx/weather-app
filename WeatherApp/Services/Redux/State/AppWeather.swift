import Redux_ReactiveSwift
import Result

struct AppWeather: Encodable, Equatable {
  let currentLocation: WeatherRequestState
  let selectedLocations: [Int]
  let allLocations: [Int: WeatherRequestState]
}

enum WeatherRequestState: AutoEncodable, Equatable {
  case selected
  case updating
  case success(current: Weather)
  case error(value: AnyError)
}

extension AppWeather: Defaultable {
  static var defaultValue = AppWeather(
    currentLocation: .selected,
    selectedLocations: [],
    allLocations: [:]
  )
}

extension AppWeather {
  static func reudce(_ state: AppWeather, _ event: AppEvent) -> AppWeather {
    switch event {
    case is BeginUpdateWeather:
      return AppWeather(
        currentLocation: .updating,
        selectedLocations: state.selectedLocations,
        allLocations: state.allLocations
      )
    case let event as DidUpdateWeather:
      return AppWeather(
        currentLocation: event.result.analysis(
          ifSuccess: { .success(current: $0) },
          ifFailure: { .error(value: $0) }),
      selectedLocations: state.selectedLocations,
      allLocations: state.allLocations)
    case let event as SelectLocation:
      var locations = state.allLocations
      locations[event.id] = .selected
      return AppWeather(
        currentLocation: state.currentLocation,
        selectedLocations: state.selectedLocations + [event.id],
        allLocations: locations)
    case let event as DeselectLocations:
      var locations = state.allLocations
      locations[event.id] = .none
      var selectedLocations = state.selectedLocations
      selectedLocations.removeAll { $0 == event.id }
      return AppWeather(
        currentLocation: state.currentLocation,
        selectedLocations: selectedLocations,
        allLocations: locations)
    default: return state
    }
  }
}
