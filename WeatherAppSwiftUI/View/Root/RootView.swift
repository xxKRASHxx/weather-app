import SwiftUI

struct RootView<RequestedView: View, NotRequestedView: View>: View, DataDriven {

  let requested: () -> RequestedView
  let notRequested: () -> NotRequestedView
  
  var props: Props = .notRequested; enum Props {
    case requested
    case notRequested
  }
  
  var body: some View {
    switch props {
    case .requested: return AnyView(requested())
    case .notRequested: return AnyView(notRequested())
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  
  static var previews: some View {
    Group {
      RootView(
        requested: { Text("Enabled") },
        notRequested: { Text("Disabled") },
        props: .notRequested
      )
    }
  }
}
