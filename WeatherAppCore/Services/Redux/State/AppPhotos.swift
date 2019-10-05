import WeatherAppShared
import Redux_ReactiveSwift
import struct Result.AnyError

public struct AppPhotos: Encodable, Equatable {
  public enum Status: AutoEncodable, Equatable {
    case notStarted
    case inProgress
    case completed(result: URL)
    case failed(error: PhotosAPIError)
    
    public var url: URL? {
      guard case let .completed(result) = self else { return nil }
      return result
    }
  }
  
  public let sights: [WoeID: Status]
}

extension AppPhotos: Defaultable {
  public static var defaultValue: AppPhotos = .init(sights: [:])
}

extension AppPhotos {
  static func reduce(_ state: AppPhotos, _ event: AppEvent) -> AppPhotos {
    switch event {
    case let event as BeginUpdateWeather:
      return AppPhotos(sights: event.ids.reduce(into: state.sights, { (result, id) in
        result[id] = .notStarted
      }))
    case let event as DidStartPhotoSearching:
      return AppPhotos(sights: state.sights
        .merging([event.id: .inProgress], uniquingKeysWith: takeSecond)
      )
    case let event as DidFinishPhotoSearching:
      
      let delta: [WoeID: Status] = event.result.analysis(
        ifSuccess: { [event.id: .completed(result: $0)] },
        ifFailure: { [event.id: .failed(error: $0)] }
      )
      return AppPhotos(sights: state.sights.merging(delta, uniquingKeysWith: takeSecond))
      
    default: return state
    }
  }
}
