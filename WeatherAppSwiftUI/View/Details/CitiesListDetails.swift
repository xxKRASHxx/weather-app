import SwiftUI
import MapKit
import KingfisherSwiftUI
import Overture



struct CenteringColumnPreference: Equatable {
  let width: CGFloat
}

struct CitiesListDetails<Row: DataDrivenView>: DataDrivenView where Row.Props: Identifiable {
  
  let row: (Row.Props) -> Row
  
  var props: Props; struct Props {
    let id: String
    let image: URL?
    let city: String
    let country: String
    let condition: String
    let coordinate: CLLocationCoordinate2D
    let forecast: [Row.Props]
  }
  
  var body: some View {
    ZStack {
      VStack {
        MapView(coordinate: props.coordinate)
          .edgesIgnoringSafeArea([.top, .horizontal])
          .frame(height: 150)
          .disabled(true)
        Spacer()
      }
      ScrollView {
        Spacer().frame(height: 150)
        VStack {
          KFImage(
            props.image,
            options: [
              .transition(.fade(0.2)) ])
            .placeholder { Image("default_background") }
            .resizable()
            .clipShape(Circle())
            .overlay(
              Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .frame(width: 200, height: 200)
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
        }
        ForEach(props.forecast, content: row)
      }
    }
  }
}

struct CitiesListDetails_Previews: PreviewProvider {
  static var previews: some View {
    CitiesListDetails(
      row: CitiesListDetailsRow.init(props:),
      props: .init(
        id: UUID().uuidString,
        image: URL(string: "https://cdn.britannica.com/91/151991-050-B1AC2CEC/Freedom-Square-Kharkiv-Ukraine.jpg"),
        city: "Kharkiv",
        country: "Ukraine",
        condition: "8ºC, Cloudy",
        coordinate: .init(
          latitude: 34.011286,
          longitude: -116.166868),
        forecast: (0...7).map { _ in .initial }
      ))
  }
}
