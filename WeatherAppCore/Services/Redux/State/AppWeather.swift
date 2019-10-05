import WeatherAppShared
import Redux_ReactiveSwift
import struct Result.AnyError

public struct AppWeather: Encodable, Equatable {
  public var current: WoeID?
  public var locations: Set<WoeID>
  public let locationsMap: [WoeID: WeatherRequestState]
}

public enum WeatherRequestState: AutoEncodable, Equatable {
  case selected
  case updating
  case success(current: Weather)
  case error(value: WeatherAPIError<WoeID>)
  
  public var weather: Weather? {
    guard case let .success(weather) = self else { return nil }
    return weather
  }
}

extension AppWeather: Defaultable {
  public static var defaultValue = AppWeather(
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
        locations: event.ids.reduce(into: state.locations, { (locations, id) in
          locations.insert(id)
        }),
        locationsMap: event.ids.reduce(into: state.locationsMap, { ( map, id) in
          map[id] = .updating
        })
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
