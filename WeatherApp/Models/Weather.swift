import Foundation

struct Weather: Codable, Equatable {
  
  let location: Location; struct Location: Codable, Equatable {
    let woeid: Int
    let city: String
    let country: String
    let coordinates: Coordinates2D
  }
  
  let forecasts: [Forecast]; struct Forecast: Codable, Equatable {
    let date: Date
    let low: Double
    let high: Double
    let text: String
  }
  
  let now: Now; struct Now: Codable, Equatable {
    let wind: Wind; struct Wind: Codable, Equatable {
      let chill: Double
      let direction: Double
      let speed: Double
    }
    
    let condition: Condition; struct Condition: Codable, Equatable {
      let text: String
      let temperature: Double
    }
    
    let atmosphere: Atmosphere; struct Atmosphere: Codable, Equatable {
      let visibility: Double
      let pressure: Double
    }
    
    let astronomy: Astronomy; struct Astronomy: Codable, Equatable {
      let sunrise: String
      let sunset: String
    }
  }
}

extension Weather: CustomDebugStringConvertible {
  var debugDescription: String {
    return """
    \(location.city), \(location.country)
    \(now.condition.text)
    Temp: \(now.condition.temperature) ºC
    Wind: \(now.wind.speed) m/s, dir \(now.wind.direction)
    """
  }
}
