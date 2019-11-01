import UIKit
import SwiftUI
import WeatherAppCore
import Overture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = scene as? UIWindowScene else {
      fatalError("\(scene) must be type of UIWindowScene")
    }
    
    WeatherAppCore.initialize()
    
    window = UIWindow(windowScene: windowScene)
    
    window?.rootViewController = UIHostingController(rootView:
      StoreProvider {
        RootPresenter {
          RootView(requested: self.requestedView, notRequested: self.notRequestedView)
        }
      }
    )
    window?.makeKeyAndVisible()
  }
  
  private func requestedView() -> CitiesListPresenter<
    CitiesListRowPresenter,
    CitiesListDetailsPresenter<CitiesListDetailsRowPresenter>,
    SearchListPresenter<SearchListRowPresenter>> {
      
      CitiesListPresenter(
        rowContenxt: CitiesListRow.init,
        rowPresenter: CitiesListRow.init
         |> flip(curry(CitiesListRowPresenter.init(item:content:))),
        detailsPresenter: { woeid in
          CitiesListDetailsPresenter(
            item: woeid,
            rowContenxt: CitiesListDetailsRow.init,
            rowPresenter: { index in
              CitiesListDetailsRowPresenter(
                item: woeid,
                index: index,
                content: CitiesListDetailsRow.init) }) },
        searchPresenter: {
          SearchListPresenter(
            rowContenxt: SearchListRow.init,
            rowPresenter: SearchListRow.init
              |> flip(curry(SearchListRowPresenter.init(item:content:))))
      })
  }
  
  private func notRequestedView() -> some View {
    PermissionsPresenter(content: RequestPermissionsView.init)
  }
}
