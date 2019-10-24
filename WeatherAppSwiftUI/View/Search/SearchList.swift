import SwiftUI
import Redux_ReactiveSwift

struct SearchList<Row: DataDrivenView>: DataDrivenView
where Row.Props: Identifiable {
  
  @State private var searchText: String = ""
  @State private var isSearchActive: Bool = false
  
  let row: (Row.Props) -> Row
  
  var props: Props = .init(list: []); struct Props {
    let list: [Landmark]; struct Landmark: Identifiable {
      var id: Row.Props.ID { props.id }
      let props: Row.Props
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SearchView(
          searchText: $searchText,
          isActive: $isSearchActive
        ).padding(.top)
        
        List(props.list) { item in
          self.row(item.props)
        }
      }
      .navigationBarHidden(isSearchActive)
        .animation(.default)
      .navigationBarTitle(Text("Search"))
      .resignKeyboardOnDragGesture()
    }
  }
}

struct SearchList_Previews: PreviewProvider {
  static var previews: some View {
    SearchList<SearchListRow>(row: { _ in
      SearchListRow()
    })
  }
}
