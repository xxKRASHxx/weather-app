public protocol AppStoreAccessable {
  var store : AppStore { get }
}

public extension AppStoreAccessable {
  var store : AppStore {
    return AppStore.shared
  }
}
