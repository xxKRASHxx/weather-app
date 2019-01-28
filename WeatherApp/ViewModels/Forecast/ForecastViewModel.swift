import ReactiveSwift
import Result

protocol ForecastViewModelProtocol: BaseViewModelProtocol {
  var description: Property<String> { get }
  var back: Action<(), (), NoError> { get }
}

class ForecastViewModel: BaseViewModel, ForecastViewModelProtocol {
  
  private let woeid: AppWeather.WoeID
  
  var back: Action<(), (), NoError> {
    return .init(weakExecute: weakify(Actions.backProducer, object: self))
  }
  
  var description: Property<String> {
    return Property(
      initial: "",
      then: store.producer
        .map(\AppState.weather.locationsMap)
        .filterMap { $0[self.woeid]?.weather } //<<<<< retain
        .map { String(describing: $0) }
    )
  }
  
  required init(woeid: AppWeather.WoeID) {
    self.woeid = woeid
    super.init()
    setupObserving()
  }
  
  required init() {
    fatalError("init(woeid:) must be used.")
  }
}

private typealias Observing = ForecastViewModel
private extension Observing {
  func setupObserving() {
    
  }
}

private typealias Actions = ForecastViewModel
private extension Actions {
  func backProducer() -> SignalProducer<(), NoError> {
    router.perform(route: .dismiss)
    return .empty
  }
}
