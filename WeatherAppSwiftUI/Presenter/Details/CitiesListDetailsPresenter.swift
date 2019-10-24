import SwiftUI
import WeatherAppCore

struct CitiesListDetailsPresenter: ItemPresenter {
  
  let item: WoeID
  let content: () -> CitiesListDetails
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesListDetails.Props { .init(
      id: String(describing: item.value),
      title: String(describing: state.weather.locationsMap[item]?.weather))
  }
}
