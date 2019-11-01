import SwiftUI

struct CitiesListDetailsRow: DataDrivenView {
  
  var props: Props = .initial; struct Props: Identifiable {
    let id = UUID().uuidString
    
    let day: String
    let condition: Condition; enum Condition: String {
      case tropicalStorm = "tropicalstorm"
    }
    let low: String
    let high: String
    
    static var initial = Props(
      day: "Monday",
      condition: .tropicalStorm,
      low: "-4",
      high: "3"
    )
  }
  
  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text(props.day)
        
      Spacer()
      Image(systemName: props.condition.rawValue)
      Spacer()
      Text(props.high)
      Text(props.low)
        .foregroundColor(Color(.secondaryLabel))
    }
    .padding(.horizontal)
  }
}

struct CitiesListDetailsRow_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CitiesListDetailsRow().previewLayout(.fixed(
        width: 320, height: 44))
      
      List(0..<5) { _ in
        CitiesListDetailsRow()
      }
      
      List(0..<5) { _ in
        CitiesListDetailsRow()
      }.preferredColorScheme(.dark)
    }
  }
}
