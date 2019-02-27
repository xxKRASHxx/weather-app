import Redux_ReactiveSwift
import ReactiveSwift
import ReactiveCocoa
import Result

extension MQTTMiddleware {
  struct LoggerFlags: OptionSet {
    let rawValue: Int
    static let logEvents = LoggerFlags(rawValue: 1 << 0)
    static let logStates = LoggerFlags(rawValue: 1 << 1)
    static let logAll: LoggerFlags = [.logEvents, .logStates]
    init(rawValue: Int) { self.rawValue = rawValue }
  }
}

class MQTTMiddleware: StoreMiddleware, MQTTServiceAccessible {
  
  private let flags: LoggerFlags
  private let name: String?
  
//  private lazy var logEvent: Action<AppState, (), AnyError> = mqttService.publish(in: "store/event")
  private lazy var logState: Action<AppState, (), AnyError> = mqttService.publish(in: "store/state")
  
  private let events = Signal<AppEvent, NoError>.pipe()
  private let states = Signal<AppState, NoError>.pipe()
  
  public init(
    flags: LoggerFlags = .logAll,
    name: String? = nil
    )
  {
    self.flags = flags
    self.name = name
    setupObserving()
  }
  
  func consume<Event>(event: Event) -> SignalProducer<Event, NoError>? {
    return SignalProducer(value:
      TypeDispatcher.value(event)
        .dispatch { (event: AppEvent) in events.input.send(value: event) }
        .extract()
    )
  }
  
  func stateDidChange<State>(state: State) {
    TypeDispatcher.value(state)
      .dispatch { (state: AppState) in states.input.send(value: state) }
  }
  
  func unsafeValue() -> Signal<Any, NoError>? { return nil }
}

private typealias Observing = MQTTMiddleware
private extension Observing {
  func setupObserving() {
//    logEvents <~ events.output.throttle(0.5, on: QueueScheduler.main)
    logState <~ states.output.throttle(0.5, on: QueueScheduler.main)
  }
}
