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
          RootView(
            requested: { CitiesListPresenter(
              rowContenxt: CitiesListRow.init,
              rowPresenter: flip(curry(CitiesListRowPresenter.init(item:content:)))(CitiesListRow.init),
              detailsPresenter: flip(curry(CitiesListDetailsPresenter.init(item:content:)))(CitiesListDetails.init),
              searchPresenter: {
                SearchListPresenter(
                  rowContenxt: SearchListRow.init,
                  rowPresenter: flip(curry(SearchListRowPresenter.init(item:content:)))(SearchListRow.init))
            }) },
            notRequested: { PermissionsPresenter(content: RequestPermissionsView.init) }
          )
        }
      }
    )
    window?.makeKeyAndVisible()
  }
}
