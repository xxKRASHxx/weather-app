import SwiftUI
import WeatherAppCore
import CoreLocation

struct CitiesListDetailsPresenter: ItemPresenter {
  
  let item: WoeID
  let content: () -> CitiesListDetails
  
  private let formatter = MeasurementFormatter()
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> CitiesListDetails.Props {
      
      guard let weather = state.weather.locationsMap[item]?.weather else {
        return .initial
      }
      
      let preview = state.photos.sights[item]
      
      return .init(
        id: String(describing: item.value),
        image: preview?.url,
        city: weather.location.city,
        country: weather.location.country,
        condition: "\(formatter.string(from: weather.now.condition.temperature)) \(weather.now.condition.text)",
        coordinate: .init(coordinates2D: weather.location.coordinates))
  }
}

private extension CLLocationCoordinate2D {
  init(coordinates2D: Coordinates2D) {
    self.init(
      latitude: coordinates2D.latitude,
      longitude: coordinates2D.longitude)
  }
}
