import WeatherAppCore
import SwiftUI
import Combine
import ReactiveSwift

private var _objectWillChangeKey = "com.key.store.objectWillChange"

extension AppStore: ObservableObject {
  public var objectWillChange: ObservableObjectPublisher {
    guard
      let willChange = objc_getAssociatedObject(self, &_objectWillChangeKey)
        as? ObservableObjectPublisher
      else {
        let willChange = ObservableObjectPublisher()
        
        signal
          .observe(on: QueueScheduler.main)
          .map(value: ())
          .observeValues(willChange.send)
        
        objc_setAssociatedObject(
          self,
          &_objectWillChangeKey,
          willChange,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return willChange
    }
    return willChange
  }
}


struct StoreConnector<V: View & DataDriven>: View {
  @EnvironmentObject var store: AppStore
  let content: (AppState, @escaping (AppEvent) -> Void) -> V
  var body: V { content(store.value, store.consume(event:)) }
}
