import SwiftUI

typealias DataDrivenView = View & DataDriven

protocol DataDriven {
  associatedtype Props
  var props: Props { get set }
}
