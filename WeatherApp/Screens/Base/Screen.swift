import UIKit
import ReactiveSwift
import ReactiveCocoa
import struct Result.AnyError

class Screen: UIViewController, ViewModelConnectable {
  
  private(set) var _viewModel: BaseViewModelProtocol?
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
    self.reactive
      .signal(for: #selector(viewDidLoad))
      .take(first: 1)
      .map { [weak self] _ in return self as? ScreenProtocol }
      .skipNil()
      .observeValues { $0.setupAll() }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) should not be called on Screen descendants")
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  @discardableResult
  func connectViewModel(_ viewModel: BaseViewModelProtocol?) -> Disposable {
    let disposableBag = CompositeDisposable()
    _viewModel = viewModel
    return disposableBag
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  override var prefersStatusBarHidden: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return [.portrait] }
  override var shouldAutorotate: Bool { return true }
}

fileprivate extension ScreenProtocol {
  func setupAll() {
    viewHierarchy?.setupViewHierarchy()
    layout?.setupLayout()
    style?.setupStyle()
    content?.setupContent()
    observing?.setupObserving()
  }
}
