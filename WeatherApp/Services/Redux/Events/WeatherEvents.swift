import Foundation
import struct Result.AnyError

struct BeginUpdateCurrentWeather: AppEvent {
  let id: WoeID = .unknown
}

struct BeginUpdateWeather: AppEvent {
  let ids: [WoeID]
}

struct DidUpdateWeather: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Weather, WeatherAPIError<WoeID>>
}

struct DidUpdateCurrentWeather: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Weather, WeatherAPIError<WoeID>>
}
