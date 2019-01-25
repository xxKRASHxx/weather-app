protocol AppStoreAccessable {
  var store : AppStore { get }
}

extension AppStoreAccessable {
  var store : AppStore {
    return AppStore.shared
  }
}
