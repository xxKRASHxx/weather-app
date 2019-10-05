import Foundation
import ReactiveSwift
import struct Result.AnyError

protocol PermissionsViewModelProtocol: BaseViewModelProtocol {
  var skip: Action<(), (), Never> { get }
  var allowLocationUsage: Action<(), (), Never> { get }
}

class PermissionsViewModel: BaseViewModel, PermissionsViewModelProtocol {
  
  private(set) lazy var skip: Action<(), (), Never> = {
    return Action(weakExecute: weakify(PermissionsViewModel.skipClosure, object: self))
  } ()
  
  private(set) lazy var allowLocationUsage: Action<(), (), Never> = {
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
  func allowLocationUsageClosure() -> SignalProducer<(), Never> {
    store.consume(event: RequestUpdateLocation())
    return .empty
  }
  
  func skipClosure() -> SignalProducer<(), Never> {
    store.consume(event: DidChangeLocationPermission(access: false))
    return .empty
  }
}
