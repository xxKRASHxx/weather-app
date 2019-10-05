import UIKit
import TableKit
import ReactiveCocoa
import ReactiveSwift
import struct Result.AnyError
import SnapKit

class ForecastScreen: Screen {
  
  var viewModel: ForecastViewModelProtocol {
    guard let _viewModel = _viewModel as? ForecastViewModelProtocol
      else { fatalError("viewModel is not ForecastViewModelProtocol") }
    return _viewModel
  }
  
  let closeButton = UIButton(type: .custom)
  let cardView = CardView()
  let tableView = UITableView(frame: .zero, style: .plain)
  private(set) lazy var director = TableDirector(tableView: tableView)
  
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
      [base.tableView, base.cardView].forEach(base.view.addSubview)
      base.cardView.vibrancyEffectView.contentView.addSubview(base.closeButton)
    }
  }
  
  class Layout: Mixin<ForecastScreen>, LayoutProtocol {
    func setupLayout() {
      
      base.closeButton.snp.makeConstraints { make in
        make.topMargin.equalToSuperview().offset(20)
        make.rightMargin.equalToSuperview().offset(-20)
      }
      
      base.cardView.titleLabel.snp.remakeConstraints { make in
        make.top.equalTo(base.view.snp.topMargin).offset(16)
        make.leftMargin.equalTo(base.view).offset(8)
      }
      
      base.cardView.snp.makeConstraints { make in
        make.top.equalToSuperview()
        make.width.equalTo(base.view.snp.width)
        make.height.equalTo(base.cardView.snp.width)
        make.centerX.equalTo(base.view.snp.centerX)
      }
      
      base.tableView.snp.makeConstraints { make in
        make.top.equalTo(base.cardView.snp.bottom)
        make.left.equalTo(base.view)
        make.bottom.equalTo(base.view)
        make.right.equalTo(base.view)
      }
    }
  }
  
  class Style: Mixin<ForecastScreen>, StyleProtocol {
    func setupStyle() {
      base.tableView.allowsSelection = false
      base.cardView.titleLabel.font = UIFont.boldSystemFont(ofSize: 42)
      base.cardView.subtitleLabel.font = UIFont.systemFont(ofSize: 24)
    }
  }
  
  class Content: Mixin<ForecastScreen>, ContentProtocol {
    func setupContent() {
      base.closeButton.setBackgroundImage(#imageLiteral(resourceName: "cancel_button"), for: .normal)
      base.cardView.imageView.image = #imageLiteral(resourceName: "default_background")
    }
  }
  
  class Observing: Mixin<ForecastScreen>, ObservingProtocol {
    func setupObserving() {
      base.cardView.imageView.reactive.url <~ base.viewModel.image
      base.closeButton.reactive.pressed = CocoaAction(base.viewModel.back)
      base.cardView.titleLabel.reactive.text <~ base.viewModel.title
      base.cardView.subtitleLabel.reactive.text <~ base.viewModel.subtitle
      base.director.reactive.sections <~ base.viewModel.forecast
        .map { results in results.map { TableRow<ForecastTableViewCell>(item: $0) } }
        .map {
          let section = TableSection(rows: $0)
          section.footerHeight = .leastNonzeroMagnitude
          section.headerHeight = .leastNonzeroMagnitude
          return [section]
        }
    }
  }
}


