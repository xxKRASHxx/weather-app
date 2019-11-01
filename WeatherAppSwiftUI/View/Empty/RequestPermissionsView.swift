import SwiftUI

struct RequestPermissionsView: View, DataDriven {
  
  var props: Props = .initial; struct Props {
    let request: () -> Void
    static let initial: Props = .init(request: { })
  }
  
  var body: some View {
    Button(action: props.request) {
      Text("Request permissions")
    }
  }
}

struct RequestPermissionsView_Previews: PreviewProvider {
  static var previews: some View {
    RequestPermissionsView(props: .initial)
  }
}
