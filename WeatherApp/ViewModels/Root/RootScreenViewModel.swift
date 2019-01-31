import ReactiveSwift
import Result

protocol RootScreenViewModelProtocol: BaseViewModelProtocol {
  var log: SignalProducer<String?, NoError> { get }
}

class RootScreenViewModel: BaseViewModel, RootScreenViewModelProtocol {
  
  var log: SignalProducer<String?, NoError> {
    return AppStore.shared.producer
      .map(String.init(describing:))
      .observe(on: QueueScheduler.main)
  }
  
  required init() {
    super.init()
    setupObserving()
  }
  
  func setupObserving() {
    let permissionsProducer = store.producer
      .map(\AppState.location.availability)
      .map { $0 == .available || $0 == .notAvailable }
      .observe(on: QueueScheduler.main)
    
    permissionsProducer
      .filter { $0 }
      .map { _ in () }
      .startWithValues(showList)
    
    permissionsProducer
      .filter { $0 == false }
      .map { _ in () }
      .startWithValues(showPermissions)
  }
}

private extension RootScreenViewModel {
  func showPermissions() {
    router.perform(route: .permissions)
  }
  
  func showList() {
    router.perform(route: .citiesList)
  }
}
