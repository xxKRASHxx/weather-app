import SwiftUI

struct SearchListRow: DataDrivenView {
  
  var props: Props = .initial; struct Props: Identifiable {
    let id: String
    let title: String
    let select: () -> Void
    
    static let initial: Props = .init(
      id: UUID().uuidString,
      title: "item",
      select: {} )
  }
  
  var body: some View {
    Button(action: props.select) {
      Text(props.title)
    }
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
