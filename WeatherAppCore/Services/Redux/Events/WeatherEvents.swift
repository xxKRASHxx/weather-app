import Foundation
import struct Result.AnyError

public struct BeginUpdateCurrentWeather: AppEvent {
  let id: WoeID = .unknown
}

public struct BeginUpdateWeather: AppEvent {
  let ids: [WoeID]
}

public struct DidUpdateWeather: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Weather, WeatherAPIError<WoeID>>
}

public struct DidUpdateCurrentWeather: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Weather, WeatherAPIError<WoeID>>
}
