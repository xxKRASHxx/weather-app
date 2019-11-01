import SwiftUI
import WeatherAppCore
import Overture

struct CitiesListPresenter<
  RowPresenter: ItemPresenter,
  DetailsPresenter: ItemPresenter,
  SearchPresenter: Presenter
  >: Presenter where
  RowPresenter.V.Props: Identifiable,
  RowPresenter.Item == DetailsPresenter.Item,
  RowPresenter.Item == WoeID
{
  
  let rowContenxt: () -> (RowPresenter.V)
  let rowPresenter: (RowPresenter.Item) -> RowPresenter
  let detailsPresenter: (DetailsPresenter.Item) -> DetailsPresenter
  let searchPresenter: () -> SearchPresenter
  
  var content: () -> CitiesList<RowPresenter.V, DetailsPresenter.V, SearchPresenter.V> {
    return {
      CitiesList(
        row: { props -> RowPresenter.V in
          var row = self.rowContenxt()
          row.props = props
          return row },
        props: .init(
          search: { self.searchPresenter().content() },
          landmarks: []
        )
      )
    }
  }
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesList<RowPresenter.V, DetailsPresenter.V, SearchPresenter.V>.Props {
      .init(
        search: { self.searchPresenter().render(state: state, dispatch: dispatch) },
        landmarks: state.weather.locations
          .map { (rowPresenter($0), detailsPresenter($0)) }
          .map { row, details in .init(
            props: row.map(state: state, dispatch: dispatch),
            destination: { details.render(state: state, dispatch: dispatch) },
            delete: { dispatch(DeselectLocations(id: row.item)) } )
        }
      )
  }
}
