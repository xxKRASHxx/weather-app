import Foundation
import Result

struct BeginUpdateWeather: AppEvent {
  let id: WoeID
}

struct DidUpdateWeather: AppEvent {
  let timeStamp: TimeInterval
  let id: WoeID
  let result: Result<Weather, AnyError>
}
