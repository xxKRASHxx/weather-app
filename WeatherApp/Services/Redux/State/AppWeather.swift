import Redux_ReactiveSwift
import Result

struct AppWeather: Encodable, Equatable {
  var current: WoeID?
  var locations: Set<WoeID>
  let locationsMap: [WoeID: WeatherRequestState]
}

enum WeatherRequestState: AutoEncodable, Equatable {
  case selected
  case updating
  case success(current: Weather)
  case error(value: WeatherAPIError<WoeID>)
  
  var weather: Weather? {
    guard case let .success(weather) = self else { return nil }
    return weather
  }
}

extension AppWeather: Defaultable {
  static var defaultValue = AppWeather(
    current: nil,
    locations: [],
    locationsMap: [:]
  )
}

extension AppWeather {
  static func reudce(_ state: AppWeather, _ event: AppEvent) -> AppWeather {
    switch event {
    case let event as BeginUpdateCurrentWeather:
      return AppWeather(
        current: state.current,
        locations: execute {
          var locations = state.locations
          locations.insert(event.id)
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[event.id] = .updating
          return locationsMap
        }
      )
    case let event as BeginUpdateWeather:
      return AppWeather(
        current: state.current,
        locations: execute {
          var locations = state.locations
          locations.insert(event.id)
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[event.id] = .updating
          return locationsMap
        }
      )
    case let event as DidUpdateWeather:
      return AppWeather(
        current: state.current,
        locations: state.locations,
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[event.result.woeID] = event.result.analysis(
            ifSuccess: { .success(current: $0) },
            ifFailure: { .error(value: $0) })
          return locationsMap
        }
      )
    case let event as DidUpdateCurrentWeather:
      return AppWeather(
        current: event.result.woeID,
        locations: execute {
          var locations = state.locations
          locations.remove(.unknown)
          locations.insert(event.result.woeID)
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[.unknown] = .none
          locationsMap[event.result.woeID] = event.result.analysis(
            ifSuccess: { .success(current: $0) },
            ifFailure: { .error(value: $0) })
          return locationsMap
        }
      )
    case let event as SelectLocation:
      return AppWeather(
        current: state.current,
        locations: execute {
          var locations = state.locations
          locations.insert(event.id)
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[event.id] = .selected
          return locationsMap
        }
      )
    case let event as DidRetrieveSelectedIDs:
      return AppWeather(
        current: state.current,
        locations: execute {
          var locations = state.locations
          event.selected
            .map(WoeID.init)
            .forEach { locations.insert($0) }
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          event.selected
            .map(WoeID.init)
            .forEach { locationsMap[$0] = .selected }
          return locationsMap
        }
      )
    case let event as DeselectLocations:
      return AppWeather(
        current: state.current,
        locations: execute {
          var locations = state.locations
          locations.remove(event.id)
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[event.id] = .none
          return locationsMap
        }
      )
    default: return state
    }
  }
}

private extension Result where Value == Weather, Error == WeatherAPIError<WoeID> {
  var woeID: WoeID {
    return analysis(
      ifSuccess: { $0.location.woeid },
      ifFailure: { $0.reason }
    )
  }
}

extension AppWeather: CustomStringConvertible {
  var description: String {
    return """
    - current
        \(String(describing: current))
      - locations
        \(locations)
      - locationsMap
        \(locationsMap)
    """
  }
}
