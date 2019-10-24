import SwiftUI

struct CitiesListDetails: DataDrivenView {
  
  var props: Props = .initial; struct Props {
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

struct CitiesListDetails_Previews: PreviewProvider {
  static var previews: some View {
    CitiesListDetails()
  }
}
