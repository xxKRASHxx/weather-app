import UIKit
import WeatherAppShared
import ReactiveCocoa
import ReactiveSwift

class RootScreen: Screen {
  
  var viewModel: RootScreenViewModelProtocol {
    guard let _viewModel = _viewModel as? RootScreenViewModelProtocol
      else { fatalError("viewModel is not RootScreenViewModelProtocol") }
    return _viewModel
  }
  
  override func loadView() {
    self.view = UITextView()
  }
  
  var textView: UITextView {
    return view as! UITextView
  }
}

extension RootScreen: ScreenProtocol {
  var viewHierarchy: ViewHierarchyProtocol? { return nil }
  var layout: LayoutProtocol? { return nil }
  var style: StyleProtocol? { return nil }
  var content: ContentProtocol? { return nil }
  var observing: ObservingProtocol? { return Observing { self } }
  
  class Observing: Mixin<RootScreen>, ObservingProtocol {
    func setupObserving() {
      base.textView.reactive.text <~ base.viewModel.log.map {
        "\(self.base.textView.text ?? "")\n\n\($0!)"
      }
    }
  }
}
