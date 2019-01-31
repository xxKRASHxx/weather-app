import Swinject
import ReactiveSwift
import Result

class StorageService: AppStoreAccessable, UserDefaultsAccessable {
  
  static let shared: StorageService = StorageService()
  
  private init() {
    setupObserving()
  }
}

private typealias Observing = StorageService
private extension Observing {
  
  func setupObserving() {
    let typeProducer : SignalProducer<AppSync.SyncType, NoError> = store.producer
      .map(\AppState.sync)
      .filterMap { state in
        guard case let .notSynced(type) = state else { return nil }
        return type
      }
    
    setupWriteObserving(with: typeProducer)
    setupReadObserving(with: typeProducer)
  }
  
  func setupWriteObserving(with producer: SignalProducer<AppSync.SyncType, NoError>) {
    producer
      .filter { $0 == .write }
      .map { _ in () }
      .map(getSyncData)
      .map(userDefaultsStorage.selectedCities.store)
      .map(DidStoreSelectedIDs.init)
      .observe(on: QueueScheduler.main)
      .startWithValues(store.consume)
  }
  
  func setupReadObserving(with producer: SignalProducer<AppSync.SyncType, NoError>) {
    producer
      .filter { $0 == .read }
      .map { _ in () }
      .map(userDefaultsStorage.selectedCities.retrieve)
      .skipNil()
      .map(DidRetrieveSelectedIDs.init)
      .observe(on: QueueScheduler.main)
      .startWithValues(store.consume)
  }
}

private typealias UserDefaults = StorageService
private extension UserDefaults {
  
  func getSyncData() -> [Int] {
    let all = store.value.weather.locations.map { $0.value }
    guard let current = store.value.weather.current
      else { return all }
    return all.filter { $0 != current.value }
  }
}
