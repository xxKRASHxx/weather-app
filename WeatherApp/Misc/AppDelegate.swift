import UIKit
import Swinject
import WeatherAppCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var uiRouter: ScreenRouter!
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
      setupUI()
      setupStore()
      setupLogging()
      return true
  }
}

private extension AppDelegate {
  
  func setupUI() {
    let newWindow = UIWindow()
    self.window = newWindow
    self.uiRouter = ScreenRouter(window: newWindow)
    let router = Container.default.resolver.resolve(ViewModelRouterProtocol.self)
    router!.perform(route: .root)
  }
  
  func setupStore() {
    WeatherAppCore.initialize()
  }
  
  func setupLogging() {
    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
  }
}
