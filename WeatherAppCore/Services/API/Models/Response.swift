import Moya

public enum Response {
  
  public struct Weather: Decodable {
    
    enum CodingKeys: String, CodingKey {
      case location
      case current = "current_observation"
      case forecasts
    }
    
    public let location: Coord; public struct Coord: Decodable {
      public let long: Double
      public let lat: Double
      public let city: String
      public let country: String
      public let woeid: Int
    }
    
    public let current: Main; public struct Main: Decodable {
      
      public let wind: Wind; public struct Wind: Decodable {
        public let chill: Double
        public let direction: Double
        public let speed: Double
      }
      
      public let condition: Condition; public struct Condition: Decodable {
        public let text: String
        public let temperature: Double
      }
      
      public let atmosphere: Atmosphere; public struct Atmosphere: Decodable {
        public let pressure: Double
        public let visibility: Double
      }
      
      public let astronomy: Astronomy; public struct Astronomy: Decodable {
        public let sunrise: String
        public let sunset: String
      }
    }
    
    public let forecasts: [Forecast]; public struct Forecast: Decodable {
      public let date: Date
      public let low: Double
      public let high: Double
      public let text: String
      public let code: Condition; public enum Condition: Int, Decodable {
        case tornado
        case tropicalStorm
        case hurricane
        case severeThunderstorms
        case thunderstorms
        case mixedRainSnow
        case mixedRainSleet
        case mixedSnowSleet
        case freezingDrizzle
        case drizzle
        case freezingRain
        case showers
        case rain
        case snowFlurries
        case lightSnowShowers
        case blowingSnow
        case snow
        case hail
        case sleet
        case dust
        case foggy
        case haze
        case smoky
        case blustery
        case windy
        case cold
        case cloudy
        case mostlyCloudyNight
        case mostlyCloudyDay
        case partlyCloudyNnight
        case partlyCloudyDay
        case clearNight
        case sunny
        case fairNight
        case fairDay
        case mixedRainHail
        case hot
        case isolatedThunderstorms
        case scatteredThunderstorms
        case scatteredShowersDay
        case heavyRain
        case scatteredSnowShowersDay
        case heavySnow
        case blizzard
        case notAvailable
        case scatteredShowersNight
        case scatteredSnowShowersNight
        case scatteredThundershowers
      }
    }
  }
  
  public struct SearchResult: Decodable {
    public let woeid: Int
    public let lon: Double
    public let lat: Double
    public let city: String
    public let country: String
    public let qualifiedName: String
  }
  
  public struct PhotoResult: Decodable {
    public let photos: Photos; public struct Photos: Decodable {
      public let photo: [PhotoInfo]; public struct PhotoInfo: Decodable {
        public let id: String
        public let secret: String
        public let server: String
        public let farm: Int
        public let title: String
      }
    }
  }
}
