import WeatherAppShared
import Redux_ReactiveSwift
import struct Result.AnyError
import Overture

public struct AppWeather: AutoLenses, Encodable, Equatable {
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
      return state
        |> AppWeather.locationsLens *~ state.locations.inserting(event.id)
        |> AppWeather.locationsMapLens *~ state.locationsMap.appending(event.id, .updating)
      
    case let event as BeginUpdateWeather:
      return state
        |> AppWeather.locationsLens *~ event.ids
          .reduce(into: state.locations, { (locations, id) in locations.insert(id) })
        |> AppWeather.locationsMapLens *~ event.ids
          .reduce(into: state.locationsMap, { ( map, id) in map[id] = .updating })

    case let event as DidUpdateWeather:
      return state
        |> AppWeather.locationsMapLens *~ state.locationsMap
          .appending(
            event.result.woeID,
            event.result.analysis(
              ifSuccess: WeatherRequestState.success,
              ifFailure: WeatherRequestState.error))

    case let event as DidUpdateCurrentWeather:
      return state
        |> AppWeather.locationsLens *~ state.locations.removing(.unknown)
        |> AppWeather.locationsLens *~ state.locations.inserting(event.result.woeID)
        |> AppWeather.locationsMapLens *~ state.locationsMap.appending(.unknown, nil)
        |> AppWeather.locationsMapLens *~ state.locationsMap
          .appending(
            event.result.woeID,
            event.result.analysis(
              ifSuccess: WeatherRequestState.success,
              ifFailure: WeatherRequestState.error))

    case let event as SelectLocation:
      return state
        |> AppWeather.locationsLens *~ state.locations.inserting(event.id)
        |> AppWeather.locationsMapLens *~ state.locationsMap.appending(event.id, .selected)

    case let event as DidRetrieveSelectedIDs:
      let woeIDs = event.selected.map(WoeID.init)
      return state
        |> AppWeather.locationsLens *~ woeIDs.reduce(state.locations, { $0.inserting($1) })
        |> AppWeather.locationsMapLens *~ woeIDs.reduce(into: state.locationsMap, { $0[$1] = .selected })

    case let event as DeselectLocations:
      return state
        |> AppWeather.locationsLens *~ state.locations.removing(event.id)
        |> AppWeather.locationsMapLens *~ state.locationsMap.appending(event.id, nil)

    default: return state
    }
  }
}

private extension Result where Value == Weather, Error == WeatherAPIError<WoeID> {
  var woeID: WoeID {
    return analysis(
      ifSuccess: Overture.get(\.location.woeid),
      ifFailure: Overture.get(\.reason)
    )
  }
}
