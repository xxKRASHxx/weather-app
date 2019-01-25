import ReactiveSwift

protocol ViewModelConnectable {
  
  var _viewModel: BaseViewModel? { get }
  
  @discardableResult
  func connectViewModel(_ viewModel: BaseViewModel?) -> Disposable
}
