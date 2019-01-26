import Foundation
import Result

struct BeginSearching: AppEvent {
  let text: String
}

struct DidEndSearch: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<[SearchResult], AnyError>
}

struct SelectLocation: AppEvent {
  let id: Int
}

struct DeselectLocations: AppEvent {
  let id: Int
}
