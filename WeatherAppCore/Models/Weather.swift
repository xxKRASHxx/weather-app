import Foundation

public struct Weather: Codable, Equatable {
  
  public let location: Location; public struct Location: Codable, Equatable {
    public let woeid: WoeID
    public let city: String
    public let country: String
    public let coordinates: Coordinates2D
  }
  
  public let forecasts: [Forecast]; public struct Forecast: Codable, Equatable {
    public let date: Date
    public let low: Double
    public let high: Double
    public let text: String
  }
  
  public let now: Now; public struct Now: Codable, Equatable {
    public let wind: Wind; public struct Wind: Codable, Equatable {
      public let chill: Double
      public let direction: Double
      public let speed: Double
    }
    
    public let condition: Condition; public struct Condition: Codable, Equatable {
      public let text: String
      public let temperature: Double
    }
    
    public let atmosphere: Atmosphere; public struct Atmosphere: Codable, Equatable {
      public let visibility: Double
      public let pressure: Double
    }
    
    public let astronomy: Astronomy; public struct Astronomy: Codable, Equatable {
      public let sunrise: String
      public let sunset: String
    }
  }
}
