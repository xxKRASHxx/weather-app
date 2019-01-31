import Redux_ReactiveSwift
import Result

struct AppPhotos: Encodable, Equatable {
  enum Status: AutoEncodable, Equatable {
    case notStarted
    case inProgress
    case completed(result: Result<URL, PhotosAPIError>)
    
    var url: URL? {
      guard case let .completed(result) = self else { return nil }
      return result.value
    }
  }
  
  let sights: [WoeID: Status]
}

extension AppPhotos: Defaultable {
  static var defaultValue: AppPhotos = .init(sights: [.current: .notStarted])
}

extension AppPhotos {
  static func reduce(_ state: AppPhotos, _ event: AppEvent) -> AppPhotos {
    switch event {
    case let event as BeginUpdateWeather:
      return AppPhotos(sights: state.sights
        .merging([event.id: .notStarted], uniquingKeysWith: { current, new in new })
      )
    case let event as DidStartPhotoSearching:
      return AppPhotos(sights: state.sights
        .merging([event.id: .inProgress], uniquingKeysWith: { current, new in new })
      )
    case let event as DidFinishPhotoSearching:
      return AppPhotos(sights: state.sights
        .merging([event.id: .completed(result: event.result)], uniquingKeysWith: { current, new in new })
      )
    default: return state
    }
  }
}


