import SwiftUI
import WeatherAppCore
import CoreLocation

struct CitiesListDetailsPresenter<RowPresenter: ItemPresenter>: ItemPresenter
  where RowPresenter.V.Props: Identifiable, RowPresenter.Item == WoeID {
  
  let item: WoeID
  let rowContenxt: () -> (RowPresenter.V)
  let rowPresenter: (Int) -> RowPresenter
  
  var content: () -> CitiesListDetails<RowPresenter.V> {
    return {
      CitiesListDetails(
        row: { props -> RowPresenter.V in
          var row = self.rowContenxt()
          row.props = props
          return row },
        props: self.initial)
    }
  }
  
  private let formatter = MeasurementFormatter()
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesListDetails<RowPresenter.V>.Props {
      
      guard let weather = state.weather.locationsMap[item]?.weather else {
        return self.initial
      }
      
      let preview = state.photos.sights[item]
      
      return .init(
        id: String(describing: item.value),
        image: preview?.url,
        city: weather.location.city,
        country: weather.location.country,
        condition: "\(formatter.string(from: weather.now.condition.temperature)) \(weather.now.condition.text)",
        coordinate: .init(coordinates2D: weather.location.coordinates),
        forecast: weather.forecasts.indices.map { index in
          rowPresenter(index).map(state: state, dispatch: dispatch)
        })
  }
}

private extension CLLocationCoordinate2D {
  init(coordinates2D: Coordinates2D) {
    self.init(
      latitude: coordinates2D.latitude,
      longitude: coordinates2D.longitude)
  }
}

private extension CitiesListDetailsPresenter {
  var initial: CitiesListDetails<RowPresenter.V>.Props { .init(
    id: UUID().uuidString,
    image: nil,
    city: "",
    country: "",
    condition: "",
    coordinate: .init(
      latitude: 0,
      longitude: 0),
    forecast: []
    )
  }
}
