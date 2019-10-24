import SwiftUI
import WeatherAppCore

struct PermissionsPresenter: Presenter {
  
  var content: () -> RequestPermissionsView
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> RequestPermissionsView.Props {
      .init(request: { dispatch(RequestUpdateLocation()) })
  }
}
