import Redux_ReactiveSwift
import ReactiveSwift

public final class AppStore: Store<AppState, AppEvent> {
  
  public static let shared: AppStore = StoreBuilder<AppState, AppEvent, AppStore>(state: .defaultValue)
    .dispatcher(scheduler: QueueScheduler.service)
    .middleware(MQTTMiddleware())
    .reducer(AppState.reudce)
    .reducer(AppState.trottleLocationUpdates)
    .build()
}
