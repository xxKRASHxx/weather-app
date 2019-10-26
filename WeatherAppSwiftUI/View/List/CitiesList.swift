import SwiftUI
import Redux_ReactiveSwift

struct CitiesList<Row: DataDrivenView, Details: DataDrivenView, Search: DataDrivenView>: DataDrivenView
  where Row.Props: Identifiable {
  
  @State private var isSearchShown: Bool = false
  
  let row: (Row.Props) -> Row
  var props: Props
  
  struct Props {
    let search: () -> Search
    let landmarks: [Landmark]; struct Landmark: Identifiable {
      var id: Row.Props.ID { props.id }
      let props: Row.Props
      let destination: () -> Details
      let delete: () -> Void
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(props.landmarks) { landmark in
          NavigationLink(
            destination: landmark.destination(),
            label: { self.row(landmark.props) }
          )
        }.onDelete(perform: delete)
      }
      .sheet(isPresented: $isSearchShown, content: props.search)
      .navigationBarTitle(Text("Landmarks"))
      .navigationBarItems(trailing: Button(
        action: { self.isSearchShown.toggle() },
        label: { Image(systemName: "plus.circle").font(Font.title) }))
    }
  }
  
  private func delete(at offsets: IndexSet) {
    offsets.forEach { index in
      props.landmarks[index].delete()
    }
  }
}
