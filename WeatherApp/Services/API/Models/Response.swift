import Moya

enum Response {
  
  struct Forecast: Decodable {
    
    enum CodingKeys: String, CodingKey {
      case location
      case current = "current_observation"
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
