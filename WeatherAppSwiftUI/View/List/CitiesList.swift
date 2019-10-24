import SwiftUI
import Redux_ReactiveSwift

struct CitiesList<Row: DataDrivenView, Details: DataDrivenView>: DataDrivenView
  where Row.Props: Identifiable {
  
  let row: (Row.Props) -> Row
  
  var props: Props = .init(landmarks: []); struct Props {
    let landmarks: [Landmark]; struct Landmark: Identifiable {
      var id: Row.Props.ID { props.id }
      let props: Row.Props
      let destination: () -> Details
    }
  }
  
  var body: some View {
    NavigationView {
      List(props.landmarks) { landmark in
        NavigationLink(
          destination: landmark.destination(),
          label: { self.row(landmark.props) }
        )
      }.navigationBarTitle(Text("Landmarks"))
    }
  }
}
