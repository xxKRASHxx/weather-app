import SwiftUI
import WeatherAppCore
import Overture

struct SearchListPresenter<RowPresenter: ItemPresenter>: Presenter where
  RowPresenter.V.Props: Identifiable,
  RowPresenter.Item == WoeID
{
  
  let rowContenxt: () -> (RowPresenter.V)
  let rowPresenter: (RowPresenter.Item) -> RowPresenter
  
  var content: () -> SearchList<RowPresenter.V> {
    return {
      SearchList(row: { props -> RowPresenter.V in
        var row = self.rowContenxt()
        row.props = props
        return row
      })
    }
  }
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> SearchList<RowPresenter.V>.Props {
      .init(
        searchText: Binding<String>(
          get: { with(state, get(\.searching.pattern)) ?? "" },
          set: { dispatch(BeginSearching.init(text: $0)) }),
        list: state.searching.result?.value?
          .map(get(\.id))
          .map(rowPresenter)
          .map { row in .init(props: row.map(state: state, dispatch: dispatch)) }
          ?? []
      )
  }
}
