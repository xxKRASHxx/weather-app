import UIKit

enum RouteType {
  case root
  case permissions
  case citiesList
}

protocol Animator: UIViewControllerAnimatedTransitioning {
  var isPresenting: Bool { get set }
}

protocol Transition: class {
  weak var viewController: UIViewController? { get set }
  
  func open(_ viewController: UIViewController)
  func close(_ viewController: UIViewController)
}

protocol Closable: class {
  func close()
}
