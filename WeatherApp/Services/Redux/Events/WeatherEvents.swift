import Foundation
import Result

struct BeginUpdateWeather: AppEvent {
  let id: AppWeather.WoeID
}

struct DidUpdateWeather: AppEvent {
  let timeStamp: TimeInterval
  let id: AppWeather.WoeID
  let result: Result<Weather, AnyError>
}
