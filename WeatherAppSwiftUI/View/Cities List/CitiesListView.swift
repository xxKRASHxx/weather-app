import SwiftUI
import Redux_ReactiveSwift

struct CitiesListView<Row: DataDrivenView>: DataDrivenView where Row.Props: Identifiable {
  
  let row: (Row.Props) -> Row
  
  var props: Props = .init(landmarks: []); struct Props {
    let landmarks: [Row.Props]
  }
  
  var body: some View {
    NavigationView {
      List(props.landmarks, rowContent: row)
        .navigationBarTitle(Text("Landmarks"))
    }
  }
}
