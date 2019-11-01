import SwiftUI

struct CitiesListRow: DataDrivenView {
  
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
    Group {
      CitiesListRow().previewLayout(.fixed(
        width: 320, height: 44))
      
      List(0..<5) { _ in
        CitiesListRow()
      }
        
      List(0..<5) { _ in
        CitiesListRow()
      }.preferredColorScheme(.dark)
    }
  }
}
