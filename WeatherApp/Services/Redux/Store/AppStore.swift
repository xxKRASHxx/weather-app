import Redux_ReactiveSwift

final class AppStore: Store<AppState, AppEvent> {
  
  static let shared: AppStore = AppStore()
  
  private init() {
    super.init(
      state: AppState.defaultValue,
      reducers: [
        AppState.reudce,
        AppState.trottleLocationUpdates // Don't do update if location succeeded within last 5 minutes
      ]
    )
  }
  
  required init(state: AppState, reducers: [AppStore.Reducer]) {
    fatalError("init(state:reducers:) cannot be called on type AppStore. Use `shared` accessor")
  }
}
