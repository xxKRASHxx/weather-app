import Moya

enum Response {
  
  struct Weather: Decodable {
    
    enum CodingKeys: String, CodingKey {
      case location
      case current = "current_observation"
      case forecasts
    }
    
    let location: Coord; struct Coord: Decodable {
      let long: Double
      let lat: Double
      let city: String
      let country: String
      let woeid: Int
    }
    
    let current: Main; struct Main: Decodable {
      
      let wind: Wind; struct Wind: Decodable {
        let chill: Double
        let direction: Double
        let speed: Double
      }
      
      let condition: Condition; struct Condition: Decodable {
        let text: String
        let temperature: Double
      }
      
      let atmosphere: Atmosphere; struct Atmosphere: Decodable {
        let visibility: Double
        let pressure: Double
      }
      
      let astronomy: Astronomy; struct Astronomy: Decodable {
        let sunrise: String
        let sunset: String
      }
    }
    
    let forecasts: [Forecast]; struct Forecast: Decodable {
      let date: Date
      let low: Double
      let high: Double
      let text: String
    }
  }
  
  struct SearchResult: Decodable {
    let woeid: Int
    let lon: Double
    let lat: Double
    let city: String
    let country: String
    let qualifiedName: String
  }
}
