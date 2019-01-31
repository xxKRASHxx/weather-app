import Foundation
import Result

struct CancelSearch: AppEvent {}

struct BeginSearching: AppEvent {
  let text: String
}

struct DidEndSearch: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<[SearchResult], AnyError>
}

struct SelectLocation: AppEvent {
  let id: WoeID
}

struct DeselectLocations: AppEvent {
  let id: WoeID
}
