import SwiftUI

struct CitiesListRow: View, DataDriven {
  
  var props: Props = .initial; struct Props: Identifiable {
    var id: String
    let title: String
    
    static let initial: Props = .init(
      id: UUID().uuidString,
      title: "initial")
  }
  
  var body: some View {
    Text(props.title)
  }
}

struct CitiesListRow_Previews: PreviewProvider {
  static var previews: some View {
    CitiesListRow()
  }
}
