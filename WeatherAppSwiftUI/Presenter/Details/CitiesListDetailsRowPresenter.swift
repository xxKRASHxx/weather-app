import SwiftUI
import WeatherAppCore
import Overture

struct CitiesListDetailsRowPresenter: ItemPresenter {
  
  let item: WoeID
  let index: Int
  let content: () -> CitiesListDetailsRow
  
  private let temperatureFormatter = MeasurementFormatter()
  private let dateFormatter: DateFormatter = with(DateFormatter()) { dateFormatter in
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
  }
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesListDetailsRow.Props {
      
      guard let weather = state.weather.locationsMap[item]?.weather else {
        return self.initial
      }
      
      return with(weather.forecasts[index]) { forecast in
        .init(
          day: dateFormatter.string(from: forecast.date),
          condition: .tropicalStorm,
          low: temperatureFormatter.string(from: forecast.low),
          high: temperatureFormatter.string(from: forecast.high)
        )
      }
  }
}

private extension CitiesListDetailsRowPresenter {
  var initial: CitiesListDetailsRow.Props { .init(
    day: "",
    condition: .tropicalStorm,
    low: "",
    high: ""
    )
  }
}
