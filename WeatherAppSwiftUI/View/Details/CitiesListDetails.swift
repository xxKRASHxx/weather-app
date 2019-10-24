import SwiftUI
import MapKit

struct CitiesListDetails: DataDrivenView {
  
  var props: Props = .initial; struct Props {
    var id: String
    let city: String
    let country: String
    let condition: String
    let coordinate: CLLocationCoordinate2D
    
    static let initial: Props = .init(
      id: UUID().uuidString,
      city: "Kharkiv",
      country: "Ukraine",
      condition: "8ºC, Cloudy",
      coordinate: .init(
        latitude: 34.011286,
        longitude: -116.166868))
  }
  
  var body: some View {
    VStack {
      
      MapView(coordinate: props.coordinate)
        .edgesIgnoringSafeArea(.top)
        .frame(height: 300)
        .disabled(true)
      
      Image("default_background")
        .resizable()
        .clipShape(Circle())
        .overlay(
          Circle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
        .frame(width: 150, height: 150)
        .offset(y: -130)
        .padding(.bottom, -130)
      
      VStack(alignment: .leading) {
        Text(props.condition)
          .font(.title)
        HStack(alignment: .top) {
          Text(props.city)
            .font(.subheadline)
          Spacer()
          Text(props.country)
            .font(.subheadline)
        }
      }
      .padding()
      
      Spacer()
    }
  }
}

struct CitiesListDetails_Previews: PreviewProvider {
  static var previews: some View {
    CitiesListDetails()
  }
}
