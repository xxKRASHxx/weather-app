import UIKit
import CollectionKit
import ReactiveCocoa
import ReactiveSwift
import Result

class CitiesListScreen: Screen {
  
  var viewModel: CitiesListViewModelProtocol {
    guard let _viewModel = _viewModel as? CitiesListViewModelProtocol
      else { fatalError("viewModel is not CitiesListViewModelProtocol") }
    return _viewModel
  }
  
  override func loadView() {
    view = CollectionView()
  }
  
  var collectionView: CollectionView {
    return view as! CollectionView
  }
}

extension CitiesListScreen: ScreenProtocol {
  
  var viewHierarchy: ViewHierarchyProtocol? { return nil }
  var layout: LayoutProtocol? { return nil }
  var style: StyleProtocol? { return Style { self } }
  var content: ContentProtocol? { return Content { self } }
  var observing: ObservingProtocol? { return Observing { self } }
  
  class Content: Mixin<CitiesListScreen>, ContentProtocol {
    func setupContent() {
      base.navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Add",
        style: .plain,
        target: nil,
        action: nil)
    }
  }
  
  class Observing: Mixin<CitiesListScreen>, ObservingProtocol {
    func setupObserving() {
      base.collectionView.reactive.arrayDataSource(Weather.self, view: RoundedWrapperView<UILabel>.self)
        <~ base.viewModel.locations
          .map { array in ArrayDataSource<Weather>(data: array) }
          .flatMapError { _ in .empty }
      
      base.navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(base.viewModel.openSearch)
    }
  }
  
  class Style: Mixin<CitiesListScreen>, StyleProtocol {
    func setupStyle() {
      base.view.backgroundColor = .white
      base.collectionView.provider = BasicProvider(
        dataSource: ArrayDataSource<Weather>(data: []),
        viewSource: viewSource,
        sizeSource: sizeSource,
        layout: flowLayout)
    }
    
    let viewSource = ClosureViewSource { (view: RoundedWrapperView<UILabel>, weather: Weather, _) in
      view.base.backgroundColor = .white
      view.base.layer.cornerRadius = 3.0
      view.base.layer.masksToBounds = true
      view.base.numberOfLines = 0
      view.base.text = String(describing: weather)
    }
    
    let sizeSource = { (i: Int, weather: Weather, size: CGSize) -> CGSize in
      return CGSize(
        width: size.width * 3/4,
        height: size.width * 3/4
      )
    }
    
    let flowLayout = FlowLayout(
      spacing: 32,
      justifyContent: .spaceAround,
      alignItems: .center
      ).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
  }
}
