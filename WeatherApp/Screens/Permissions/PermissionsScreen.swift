import UIKit
import ReactiveSwift
import ReactiveCocoa

class PermissionsScreen: Screen {
  
  var viewModel: PermissionsViewModelProtocol {
    guard let _viewModel = _viewModel as? PermissionsViewModelProtocol
      else { fatalError("viewModel is not PermissionsViewModel") }
    return _viewModel
  }
  
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var enableLocationUpdates: UIButton!
}

extension PermissionsScreen: ScreenProtocol {
  
  class Observing: Mixin<PermissionsScreen>, ObservingProtocol {
    func setupObserving() {
      base.enableLocationUpdates.reactive.pressed = CocoaAction(base.viewModel.allowLocationUsage)
      base.skipButton.reactive.pressed = CocoaAction(base.viewModel.skip)
    }
  }
  
  var viewHierarchy: ViewHierarchyProtocol? { return nil }
  var layout: LayoutProtocol? { return nil }
  var style: StyleProtocol? { return nil }
  var content: ContentProtocol? { return  nil }
  var observing: ObservingProtocol? { return Observing { self } }
}
