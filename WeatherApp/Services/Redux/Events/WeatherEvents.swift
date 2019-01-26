import Foundation
import Result

struct BeginUpdateWeather: AppEvent {}

struct DidUpdateWeather: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Weather, AnyError>
}

struct DidUpdateLocationWeather: AppEvent {
  let woeid: Int
  let timeStamp: TimeInterval
  let result: Result<Weather, AnyError>
}
