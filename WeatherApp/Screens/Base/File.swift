import UIKit

class PortraitNavigationController: UINavigationController {
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  override var prefersStatusBarHidden: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return [.portrait] }
  override var shouldAutorotate: Bool { return true }
}
