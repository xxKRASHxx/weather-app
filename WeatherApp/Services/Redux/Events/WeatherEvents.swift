import Foundation
import Result

struct BeginUpdateWeather: AppEvent {}

struct DidUpdateWeather: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Weather, AnyError>
}
