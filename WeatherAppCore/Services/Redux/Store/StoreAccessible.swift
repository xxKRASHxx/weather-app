public protocol AppStoreAccessable {
  var store : AppStore { get }
}

public extension AppStoreAccessable {
  public var store : AppStore {
    return AppStore.shared
  }
}
