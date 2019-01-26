import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var uiRouter: ScreenRouter!
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
      setupAppDI()
      setupUI()
      setupStore()
      setupLogging()
      return true
  }
}

private extension AppDelegate {
  
  func setupAppDI() {
    Assembler.shared.apply(assemblies: appAssemblies)
    Assembler.shared.apply(assemblies: assemblies)
  }
  
  func setupUI() {
    let newWindow = UIWindow()
    self.window = newWindow
    self.uiRouter = ScreenRouter(window: newWindow)
    let router = Container.current.resolve(ViewModelRouterProtocol.self)
    router!.perform(route: .root)
  }
  
  func setupStore() {
    let _ = AppStore.shared
    let _ = LocationService.shared
    let _ = WeatherService.shared
  }
  
  func setupLogging() {
    AppStore.shared.producer.startWithValues { (state) in
      print(state)
    }
  }
}
