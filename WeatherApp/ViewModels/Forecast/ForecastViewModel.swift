import ReactiveSwift
import Result

protocol ForecastViewModelProtocol: BaseViewModelProtocol {
  var title: Property<String> { get }
  var subtitle: Property<String> { get }
  var forecast: SignalProducer<[Weather.Forecast], NoError> { get }
  var back: Action<(), (), NoError> { get }
}

class ForecastViewModel: BaseViewModel, ForecastViewModelProtocol {
  
  private let woeid: AppWeather.WoeID
  
  var back: Action<(), (), NoError> {
    return .init(weakExecute: weakify(Actions.backProducer, object: self))
  }
  
  var title: Property<String> {
    return Property(
      initial: "",
      then: store.producer
        .map(\AppState.weather.locationsMap)
        .filterMap { $0[self.woeid]?.weather } //<<<<< retain
        .map { "\($0.now.condition.temperature) ºC\n\($0.now.condition.text)" }
    )
  }
  
  var subtitle: Property<String> {
    return Property(
      initial: "",
      then: store.producer
        .map(\AppState.weather.locationsMap)
        .filterMap { $0[self.woeid]?.weather } //<<<<< retain
        .map { "\($0.location.city), \($0.location.country)" }
    )
  }
  
  var forecast: SignalProducer<[Weather.Forecast], NoError> {
    return store.producer
      .map(\AppState.weather.locationsMap)
      .map { [weak self] locations in
        guard let self = self else { return [] }
        return locations[self.woeid]?.weather?.forecasts ?? []
      }
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
