import UIKit
import TableKit
import ReactiveCocoa
import ReactiveSwift
import struct Result.AnyError

class SearchScreen: Screen {
  
  var viewModel: SearchViewModelProtocol {
    guard let _viewModel = _viewModel as? SearchViewModelProtocol
      else { fatalError("viewModel is not SearchViewModelProtocol") }
    return _viewModel
  }
  
  override func loadView() {
    view = blurEffectView
  }
  
  let tableView = UITableView(frame: .zero, style: .plain)
  let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
  
  lazy var director = TableDirector(tableView: tableView)
}

extension SearchScreen: ScreenProtocol {
  var viewHierarchy: ViewHierarchyProtocol? { return ViewHierarchy { self } }
  var layout: LayoutProtocol? { return Layout { self } }
  var style: StyleProtocol? { return Style { self } }
  var content: ContentProtocol? { return Content { self } }
  var observing: ObservingProtocol? { return Observing { self } }
  
  class ViewHierarchy: Mixin<SearchScreen>, ViewHierarchyProtocol {
    func setupViewHierarchy() {
      base.blurEffectView.contentView.addSubview(base.tableView)
    }
  }
  
  class Layout: Mixin<SearchScreen>, LayoutProtocol {
    func setupLayout() {
      base.tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
  
  class Style: Mixin<SearchScreen>, StyleProtocol {
    func setupStyle() {
      base.tableView.backgroundColor = .clear
      base.tableView.keyboardDismissMode = .interactive
    }
  }
  
  class Content: Mixin<SearchScreen>, ContentProtocol {
    func setupContent() {
      let searchBar = UISearchBar()
      searchBar.sizeToFit()
      base.navigationItem.titleView = searchBar
      base.navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: nil,
        action: nil)
    }
  }
  
  class Observing: Mixin<SearchScreen>, ObservingProtocol {
    func setupObserving() {
      
      base.reactive.viewDidAppear
        .take(first: 1)
        .observeValues { [weak base] _ in base?.navigationItem.titleView?.becomeFirstResponder() }
      
      base.director.reactive.sections <~ base.viewModel.results
        .map { results in results.map { result in
          TableRow<SearchTableViewCell>(
            item: result,
            actions: [
              TableRowAction<SearchTableViewCell>(
                .select,
                handler: weakify(Observing.tableViewSelectActionHandler, object: self)
              )
            ])
          }
        }
        .map {
          let section = TableSection(rows: $0)
          section.footerHeight = .leastNonzeroMagnitude
          section.headerHeight = .leastNonzeroMagnitude
          return [section]
        }
        .flatMapError { _ in .never }
      
      TypeDispatcher.value(base.navigationItem.titleView)
        .dispatch { (searchBar: UISearchBar) in
          _ = searchBar.reactive.continuousTextValues
            .observeValues { self.base.viewModel.search.apply($0).start() }
      }
      
      base.navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(base.viewModel.back)
    }
    
    func tableViewSelectActionHandler(_ options: TableRowActionOptions<SearchTableViewCell>) {
      options.cell?.model?.select.apply().start()
    }
  }
}

extension Reactive where Base: TableDirector {
  var sections: BindingTarget<[TableSection]> {
    return makeBindingTarget {
      $0.clear()
      $0 += $1
      $0.reload()
    }
  }
  
  func rows<Cell: UITableViewCell & ConfigurableCell>(type: Cell.Type) -> BindingTarget<[TableRow<Cell>]> {
    return makeBindingTarget {
      $0.clear()
      $0 += $1
      $0.reload()
    }
  }
}
