import ReactiveSwift

protocol ViewModelConnectable {
  
  var _viewModel: BaseViewModelProtocol? { get }
  
  @discardableResult
  func connectViewModel(_ viewModel: BaseViewModelProtocol?) -> Disposable
}
