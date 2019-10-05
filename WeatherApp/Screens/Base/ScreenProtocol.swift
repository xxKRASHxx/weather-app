protocol ScreenProtocol {
  var viewHierarchy: ViewHierarchyProtocol? { get }
  var layout: LayoutProtocol? { get }
  var style: StyleProtocol? { get }
  var content: ContentProtocol? { get }
  var observing: ObservingProtocol? { get }
}

protocol ViewHierarchyProtocol {
  func setupViewHierarchy()
}

protocol LayoutProtocol {
  func setupLayout()
}

protocol StyleProtocol {
  func setupStyle()
}

protocol ContentProtocol {
  func setupContent()
}

protocol ObservingProtocol {
  func setupObserving()
}
