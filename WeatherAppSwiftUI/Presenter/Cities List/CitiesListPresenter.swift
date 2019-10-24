import SwiftUI
import WeatherAppCore

extension WoeID: Identifiable {
  public var id: String { String(describing: value) }
}

struct CitiesListPresenter<RowPresenter: ItemPresenter>: Presenter
  where RowPresenter.V.Props: Identifiable, RowPresenter.Item == WoeID {
  
  var rowContenxt: () -> (RowPresenter.V)
  var itemPresenter: (RowPresenter.Item) -> RowPresenter
  
  var content: () -> CitiesListView<RowPresenter.V> {
    return {
      CitiesListView(row: { props -> RowPresenter.V in
        var row = self.rowContenxt()
        row.props = props
        return row
      })
    }
  }
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesListView<RowPresenter.V>.Props {
      .init(landmarks: state.weather.locations
        .map(itemPresenter)
        .map { presenter in presenter.map(state: state, dispatch: dispatch) }
      )
  }
}
