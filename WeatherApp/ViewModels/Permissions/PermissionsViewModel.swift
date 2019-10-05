import Foundation
import ReactiveSwift
import Result

protocol PermissionsViewModelProtocol: BaseViewModelProtocol {
  var skip: Action<(), (), NoError> { get }
  var allowLocationUsage: Action<(), (), NoError> { get }
}

class PermissionsViewModel: BaseViewModel, PermissionsViewModelProtocol {
  
  private(set) lazy var skip: Action<(), (), NoError> = {
    return Action(weakExecute: weakify(PermissionsViewModel.skipClosure, object: self))
  } ()
  
  private(set) lazy var allowLocationUsage: Action<(), (), NoError> = {
    return Action(
      enabledIf: Property(initial: false, then: store
        .map(\AppState.location.availability)
        .producer.map { status in status == .notYetRequested }),
      weakExecute: weakify(PermissionsViewModel.allowLocationUsageClosure, object: self)
    )
  } ()
}

private typealias ActionClosures = PermissionsViewModel
private extension ActionClosures {
  func allowLocationUsageClosure() -> SignalProducer<(), NoError> {
    store.consume(event: RequestUpdateLocation())
    return .empty
  }
  
  func skipClosure() -> SignalProducer<(), NoError> {
    store.consume(event: DidChangeLocationPermission(access: false))
    return .empty
  }
}
