import SwiftUI
import WeatherAppCore

struct CitiesListRowPresenter: ItemPresenter {
  
  let item: WoeID
  let content: () -> CitiesListRow
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesListRow.Props { .init(
      id: String(describing: item.value),
      title: String(describing: state.weather.locationsMap[item]))
  }
}
