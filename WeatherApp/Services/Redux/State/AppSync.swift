import Redux_ReactiveSwift
import Result

enum AppSync: AutoEncodable, Equatable {
  
  enum SyncType: String, Codable, Equatable {
    case read
    case write
  }
  
  case notSynced(needs: SyncType)
  case synced
}

extension AppSync: Defaultable {
  static var defaultValue: AppSync = .notSynced(needs: .read)
}

extension AppSync {
  static func reduce(_ state: AppSync, _ event: AppEvent) -> AppSync {
    switch event {
    case is SelectLocation, is DeselectLocations:
      return .notSynced(needs: .write)
    case is DidStoreSelectedIDs, is DidRetrieveSelectedIDs:
      return .synced
    default: return state
    }
  }
}
