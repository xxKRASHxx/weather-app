import SwiftUI
import WeatherAppCore
import Overture

extension WoeID: Identifiable {
  public var id: String { String(describing: value) }
}

struct CitiesListPresenter<
  RowPresenter: ItemPresenter,
  DetailsPresenter: ItemPresenter
  >: Presenter where
  RowPresenter.V.Props: Identifiable,
  RowPresenter.Item == DetailsPresenter.Item,
  RowPresenter.Item == WoeID
{
  
  let rowContenxt: () -> (RowPresenter.V)
  let rowPresenter: (RowPresenter.Item) -> RowPresenter
  let detailsPresenter: (DetailsPresenter.Item) -> DetailsPresenter
  
  var content: () -> CitiesList<RowPresenter.V, DetailsPresenter.V> {
    return {
      CitiesList(row: { props -> RowPresenter.V in
        var row = self.rowContenxt()
        row.props = props
        return row
      })
    }
  }
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesList<RowPresenter.V, DetailsPresenter.V>.Props {
      .init(landmarks: state.weather.locations
        .map { (rowPresenter($0), detailsPresenter($0)) }
        .map { row, details in .init(
          props: row.map(state: state, dispatch: dispatch),
          destination: { details.render(state: state, dispatch: dispatch) })
        }
      )
  }
}
