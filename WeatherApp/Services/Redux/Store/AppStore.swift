import Redux_ReactiveSwift
import ReactiveSwift

final class AppStore: Store<AppState, AppEvent> {
  
  static let shared: AppStore = StoreBuilder<AppState, AppEvent, AppStore>(state: .defaultValue)
    .dispatcher(scheduler: QueueScheduler.service)
    .middleware(MQTTMiddleware())
    .reducer(AppState.reudce)
    .reducer(AppState.trottleLocationUpdates)
    .build()
}
