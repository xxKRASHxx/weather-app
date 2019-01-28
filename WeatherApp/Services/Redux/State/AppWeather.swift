import Redux_ReactiveSwift
import Result

struct AppWeather: Encodable, Equatable {
  
  enum WoeID: AutoCodable, Equatable, Hashable {
    case current
    case searched(value: Int)
    
    var id: Int? {
      guard case let .searched(id) = self else { return nil }
      return id
    }
  }
  
  var locations: Set<WoeID>
  let locationsMap: [WoeID: WeatherRequestState]
}

enum WeatherRequestState: AutoEncodable, Equatable {
  case selected
  case updating
  case success(current: Weather)
  case error(value: AnyError)
}

extension AppWeather: Defaultable {
  static var defaultValue = AppWeather(
    locations: [.current],
    locationsMap: [:]
  )
}

extension AppWeather {
  static func reudce(_ state: AppWeather, _ event: AppEvent) -> AppWeather {
    switch event {
    case let event as BeginUpdateWeather:
      return AppWeather(
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
        locations: state.locations,
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[event.id] = event.result.analysis(
            ifSuccess: { .success(current: $0) },
            ifFailure: { .error(value: $0) })
          return locationsMap
        }
      )
    case let event as SelectLocation:
      return AppWeather(
        locations: execute {
          var locations = state.locations
          locations.insert(.searched(value: event.id))
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[.searched(value: event.id)] = .selected
          return locationsMap
        }
      )
    case let event as DidRetrieveSelectedIDs:
      return AppWeather(
        locations: execute {
          var locations = state.locations
          event.selected
            .map { .searched(value: $0) }
            .forEach { woeid in
              locations.insert(woeid)
            }
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          event.selected
            .map { .searched(value: $0) }
            .forEach { woeid in
              locationsMap[woeid] = .selected
            }
          return locationsMap
        }
      )
    case let event as DeselectLocations:
      return AppWeather(
        locations: execute {
          var locations = state.locations
          locations.remove(.searched(value: event.id))
          return locations
        },
        locationsMap: execute {
          var locationsMap = state.locationsMap
          locationsMap[.searched(value: event.id)] = .none
          return locationsMap
        }
      )
    default: return state
    }
  }
}
