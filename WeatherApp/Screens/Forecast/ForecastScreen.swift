import UIKit
import TableKit
import ReactiveCocoa
import ReactiveSwift
import Result
import SnapKit

class ForecastScreen: Screen {
  
  var viewModel: ForecastViewModelProtocol {
    guard let _viewModel = _viewModel as? ForecastViewModelProtocol
      else { fatalError("viewModel is not ForecastViewModelProtocol") }
    return _viewModel
  }
  
  let closeButton = UIButton(type: .system)
  let titleLabel = UILabel()
  let tableView = UITableView(frame: .zero, style: .plain)
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
  }
}

extension ForecastScreen: ScreenProtocol {
  
  var viewHierarchy: ViewHierarchyProtocol? { return ViewHierarchy { self } }
  var layout: LayoutProtocol? { return Layout { self } }
  var style: StyleProtocol? { return Style { self } }
  var content: ContentProtocol? { return Content { self } }
  var observing: ObservingProtocol? { return Observing { self } }
  
  class ViewHierarchy: Mixin<ForecastScreen>, ViewHierarchyProtocol {
    func setupViewHierarchy() {
      [base.tableView, base.titleLabel, base.closeButton].forEach(base.view.addSubview)
    }
  }
  
  class Layout: Mixin<ForecastScreen>, LayoutProtocol {
    func setupLayout() {
      
      base.closeButton.snp.makeConstraints { make in
        make.topMargin.equalToSuperview().offset(20)
        make.leftMargin.equalToSuperview().offset(20)
      }
      
      base.titleLabel.snp.makeConstraints { make in
        make.top.equalToSuperview()
        make.width.equalTo(base.view.snp.width)
        make.height.equalTo(base.titleLabel.snp.width).dividedBy(3.0/2.0)
        make.centerX.equalTo(base.view.snp.centerX)
      }
      
      base.tableView.snp.makeConstraints { make in
        make.top.equalTo(base.titleLabel.snp.bottom)
        make.left.equalTo(base.view)
        make.bottom.equalTo(base.view)
        make.right.equalTo(base.view)
      }
    }
  }
  
  class Style: Mixin<ForecastScreen>, StyleProtocol {
    func setupStyle() {
      base.titleLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    }
  }
  
  class Content: Mixin<ForecastScreen>, ContentProtocol {
    func setupContent() {
      base.closeButton.setTitle("Close", for: .normal)
      base.titleLabel.numberOfLines = 0
    }
  }
  
  class Observing: Mixin<ForecastScreen>, ObservingProtocol {
    func setupObserving() {
      base.closeButton.reactive.pressed = CocoaAction(base.viewModel.back)
      base.titleLabel.reactive.text <~ base.viewModel.description
    }
  }
}


