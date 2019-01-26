import UIKit
import TableKit
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchScreen: Screen {
  
  var viewModel: SearchViewModelProtocol {
    guard let _viewModel = _viewModel as? SearchViewModelProtocol
      else { fatalError("viewModel is not SearchViewModelProtocol") }
    return _viewModel
  }
  
  override func loadView() {
    view = UITableView(frame: .zero, style: .plain)
  }
  
  var tableView: UITableView {
    return view as! UITableView
  }
  
  lazy var director = TableDirector(tableView: tableView)
}

extension SearchScreen: ScreenProtocol {
  var viewHierarchy: ViewHierarchyProtocol? { return nil }
  var layout: LayoutProtocol? { return nil }
  var style: StyleProtocol? { return nil }
  var content: ContentProtocol? { return Content { self } }
  var observing: ObservingProtocol? { return Observing { self } }
  
  class Style: Mixin<SearchScreen>, StyleProtocol {
    func setupStyle() {
      
    }
  }
  
  class Content: Mixin<SearchScreen>, ContentProtocol {
    func setupContent() {
      let searchBar = UISearchBar()
      searchBar.sizeToFit()
      base.navigationItem.titleView = searchBar
      base.navigationItem.leftBarButtonItem = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: nil,
        action: nil)
    }
  }
  
  class Observing: Mixin<SearchScreen>, ObservingProtocol {
    func setupObserving() {
      
      base.reactive
        .signal(for: #selector(viewDidAppear(_:)))
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
      
      base.navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(base.viewModel.back)
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
}
