import UIKit

enum RouteType {
  case root
  case permissions
  case citiesList
  case search
  case forecast(woeid: AppWeather.WoeID)
  case dismiss
}

protocol Animator: UIViewControllerAnimatedTransitioning {
  var isPresenting: Bool { get set }
}

protocol Transition: class {
  var viewController: UIViewController? { get set }
  
  func open(_ viewController: UIViewController)
  func close(_ viewController: UIViewController)
}

protocol Closable: class {
  func close()
}
