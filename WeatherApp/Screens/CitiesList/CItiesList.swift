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
      base.collectionView.reactive.arrayDataSource(WeatherViewModel.self, view: RoundedWrapperView<CardView>.self)
        <~ base.viewModel.locations
          .map { array in ArrayDataSource<WeatherViewModel>(data: array) }
          .flatMapError { _ in .empty }
      
      base.reactive.title <~ base.viewModel.title
      base.navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(base.viewModel.openSearch)
      
      (base.collectionView.provider as? BasicProvider<WeatherViewModel, RoundedWrapperView<CardView>>)?
        .tapHandler = selectForecast
    }
    
    func selectForecast(_ context: BasicProvider<WeatherViewModel, RoundedWrapperView<CardView>>.TapContext) {
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
    
    let viewSource = ClosureViewSource { (view: RoundedWrapperView<CardView>, model: WeatherViewModel, _) in
      view.base.titleLabel.text
        = "\(model.weather.now.condition.temperature) ºC"
      view.base.subtitleLabel.text
        = "\(model.weather.location.city), \(model.weather.location.country)"
      view.base.imageView.reactive.url <~ model.photo
    }
    
    let sizeSource = { (i: Int, weather: WeatherViewModel, size: CGSize) -> CGSize in
      let side = (64...240).clamp((size.width / 2) - 32)
      return  CGSize(
        width: side,
        height: side
      )
    }
    
    let flowLayout = FlowLayout(
      spacing: 16,
      justifyContent: .spaceAround,
      alignItems: .center
      ).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
  }
}
