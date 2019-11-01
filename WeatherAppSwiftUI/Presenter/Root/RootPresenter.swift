import SwiftUI
import WeatherAppCore

struct RootPresenter<EnabledView: View, DisabledView: View>: Presenter {
  
  var content: () -> RootView<EnabledView, DisabledView>
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> RootView<EnabledView, DisabledView>.Props {
      switch state.location.availability {
      case .notYetRequested: return .notRequested
      default: return .requested
      }
  }
}
