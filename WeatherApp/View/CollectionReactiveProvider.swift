import ReactiveSwift
import ReactiveCocoa
import CollectionKit

extension Reactive where Base: CollectionView {
  
//  func dataSource<T>(_ type: T.Type) -> BindingTarget<DataSource<T>> {
//    return makeBindingTarget {
//      ($0.provider as? BasicProvider)?.dataSource = $1
//    }
//  }
  
  func arrayDataSource<T, U: UIView>(_ type: T.Type, view: U.Type) -> BindingTarget<ArrayDataSource<T>> {
    return makeBindingTarget {
      ($0.provider as? BasicProvider<T, U>)?.dataSource = $1
    }
  }
}
