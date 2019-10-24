import SwiftUI

struct SearchListRow: DataDrivenView {
  
  var props: Props = .initial; struct Props: Identifiable {
    let id: String
    let title: String
    
    static let initial: Props = .init(
      id: UUID().uuidString,
      title: "item")
  }
  
  var body: some View {
    Text(props.title)
  }
}

struct SearchListRow_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SearchListRow().previewLayout(
        .fixed(width: 320, height: 44))
      
      List(0..<5) { _ in
        SearchListRow()
      }
        
      List(0..<5) { _ in
        SearchListRow()
      }.preferredColorScheme(.dark)
    }
  }
}
