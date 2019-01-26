import Foundation

struct Weather: Codable, Equatable {
  
  let location: Location; struct Location: Codable, Equatable {
    let woeid: Int
    let city: String
    let country: String
    let coordinates: WeatherApp.Location
  }
  
  let direction: Double
  let speed: Double
  let text: String
  let temperature: Double
}
