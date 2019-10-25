import Redux_ReactiveSwift
import struct Result.AnyError

public struct AppSearch: AutoLenses, Encodable, Equatable {
  public let pattern: String?
  public let result: Result<[SearchResult], AnyError>?
}

extension AppSearch: Defaultable {
  public static var defaultValue = AppSearch(
    pattern: nil,
    result: nil)
}

extension AppSearch {
  static func reudce(_ state: AppSearch, _ event: AppEvent) -> AppSearch {
    switch event {
    case let action as BeginSearching:
      return state
        |> AppSearch.patternLens *~ action.text
    case let action as DidEndSearch:
      return state
        |> AppSearch.resultLens *~ action.result
    case is SelectLocation, is CancelSearch:
      return .defaultValue
    default:
      return state
    }
  }
}
