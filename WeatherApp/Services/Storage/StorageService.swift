import Swinject
import ReactiveSwift
import struct Result.AnyError

class StorageService: AppStoreAccessable, UserDefaultsAccessable {
  
  static let shared: StorageService = StorageService()
  
  private init() {
    setupObserving()
  }
}

private typealias Observing = StorageService
private extension Observing {
  
  func setupObserving() {
    let typeProducer : SignalProducer<AppSync.SyncType, Never> = store.producer
      .map(\AppState.sync)
      .filterMap { state in
        guard case let .notSynced(type) = state else { return nil }
        return type
      }
    
    setupWriteObserving(with: typeProducer)
    setupReadObserving(with: typeProducer)
  }
  
  func setupWriteObserving(with producer: SignalProducer<AppSync.SyncType, Never>) {
    producer
      .filter { $0 == .write }
      .map { _ in () }
      .map(getSyncData)
      .map(userDefaultsStorage.selectedCities.store)
      .map(DidStoreSelectedIDs.init)
      .startWithValues(store.consume)
  }
  
  func setupReadObserving(with producer: SignalProducer<AppSync.SyncType, Never>) {
    producer
      .filter { $0 == .read }
      .map { _ in () }
      .map(userDefaultsStorage.selectedCities.retrieve)
      .skipNil()
      .map(DidRetrieveSelectedIDs.init)
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
