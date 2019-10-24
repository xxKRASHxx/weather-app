import WeatherAppCore
import SwiftUI

protocol Presenter: View {
  associatedtype V: DataDrivenView
  var content: () -> V { get }
  func map(state: AppState, dispatch: @escaping (AppEvent) -> Void) -> V.Props
  func body(props: V.Props) -> V
}

extension Presenter {
  
  func render(state: AppState, dispatch: @escaping (AppEvent) -> Void) -> V {
    let props = map(state: state, dispatch: dispatch)
    return body(props: props)
  }
  
  func body(props: V.Props) -> V {
    var v = content()
    v.props = props
    return v
  }
  
  var body: StoreConnector<V> {
    return StoreConnector(content: render)
  }
}

protocol ItemPresenter: Presenter {
  associatedtype Item: Identifiable
  var item: Item { get }
}
