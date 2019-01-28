import UIKit
import CollectionKit
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero

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
  
  fileprivate(set) var selectedView: UIView? = nil
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
        barButtonSystemItem: .add, target: nil, action: nil)
    }
  }
  
  class Observing: Mixin<CitiesListScreen>, ObservingProtocol {
    func setupObserving() {
      base.collectionView.reactive.arrayDataSource(WeatherViewModel.self, view: RoundedWrapperView<UILabel>.self)
        <~ base.viewModel.locations
          .map { array in ArrayDataSource<WeatherViewModel>(data: array) }
          .flatMapError { _ in .empty }
      
      base.navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(base.viewModel.openSearch)
      
      (base.collectionView.provider as? BasicProvider<WeatherViewModel, RoundedWrapperView<UILabel>>)?
        .tapHandler = selectForecast
    }
    
    func selectForecast(_ context: BasicProvider<WeatherViewModel, RoundedWrapperView<UILabel>>.TapContext) {
      base.selectedView = context.view.base as UIView
      context.dataSource.data(at: context.index)
        .select.apply().start()
    }
  }
  
  class Style: Mixin<CitiesListScreen>, StyleProtocol {
    func setupStyle() {
      base.view.backgroundColor = .white
      base.collectionView.alwaysBounceVertical = true
      base.collectionView.provider = BasicProvider(
        dataSource: ArrayDataSource<WeatherViewModel>(data: []),
        viewSource: viewSource,
        sizeSource: sizeSource,
        layout: flowLayout)
    }
    
    let viewSource = ClosureViewSource { (view: RoundedWrapperView<UILabel>, model: WeatherViewModel, _) in
      view.base.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
      view.base.numberOfLines = 0
      view.base.text = String(describing: model.weather)
    }
    
    let sizeSource = { (i: Int, weather: WeatherViewModel, size: CGSize) -> CGSize in
      let side = (64...240).clamp(size.width)
      return  CGSize(
        width: side,
        height: side
      )
    }
    
    let flowLayout = FlowLayout(
      spacing: 32,
      justifyContent: .spaceAround,
      alignItems: .center
      ).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
  }
}

extension ClosedRange {
  func clamp(_ value : Bound) -> Bound {
    return self.lowerBound > value ? self.lowerBound
      : self.upperBound < value ? self.upperBound
      : value
  }
}
