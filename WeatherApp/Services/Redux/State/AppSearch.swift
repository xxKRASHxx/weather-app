import Redux_ReactiveSwift
import Result

enum AppSearch: AutoEncodable, Equatable {
  case none
  case searching(key: String)
  case error(value: AnyError)
  case success(result: [SearchResult])
}

extension AppSearch: Defaultable {
  static var defaultValue: AppSearch = .none
}

extension AppSearch {
  static func reudce(_ state: AppSearch, _ event: AppEvent) -> AppSearch {
    switch event {
    case let action as BeginSearching:
      return .searching(key: action.text)
    case let action as DidEndSearch:
      return action.result.analysis(
        ifSuccess: { .success(result: $0) },
        ifFailure: { .error(value: $0) })
    case is SelectLocation:
      return .none
    default: return state
    }
  }
}
