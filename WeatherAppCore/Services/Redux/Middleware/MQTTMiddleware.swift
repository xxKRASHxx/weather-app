import WeatherAppShared
import Redux_ReactiveSwift
import ReactiveSwift
import ReactiveCocoa
import struct Result.AnyError

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
  private let name: String
  
  private lazy var logEvent: Action<AnyEvent, (), AnyError> =
    mqttService.publish(in: "\(name)/store/event")
  private lazy var logState: Action<AppState, (), AnyError> =
    mqttService.publish(in: "\(name)/store/state")

  
  private let events = Signal<AppEvent, Never>.pipe()
  private let states = Signal<AppState, Never>.pipe()
  
  public init(
    flags: LoggerFlags = .logAll,
    name: String = "undefined"
    )
  {
    self.flags = flags
    self.name = name
    setupObserving()
  }
  
  func consume<Event>(event: Event) -> SignalProducer<Event, Never>? {
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
  
  func unsafeValue() -> Signal<Any, Never>? { return nil }
}

private typealias Observing = MQTTMiddleware
private extension Observing {
  func setupObserving() {
    logEvent <~ events.output.throttle(0.5, on: QueueScheduler.main).map(AnyEvent.init)
    logState <~ states.output.throttle(0.5, on: QueueScheduler.main)
  }
}
