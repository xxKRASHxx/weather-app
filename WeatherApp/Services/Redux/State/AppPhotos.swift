import Redux_ReactiveSwift
import Result

struct AppPhotos: Encodable, Equatable {
  enum Status: AutoEncodable, Equatable {
    case notStarted
    case inProgress
    case completed(result: URL)
    case failed(error: PhotosAPIError)
    
    var url: URL? {
      guard case let .completed(result) = self else { return nil }
      return result
    }
  }
  
  let sights: [WoeID: Status]
}

extension AppPhotos: Defaultable {
  static var defaultValue: AppPhotos = .init(sights: [:])
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
        .merging([event.id: .inProgress], uniquingKeysWith: new)
      )
    case let event as DidFinishPhotoSearching:
      
      let delta: [WoeID: Status] = event.result.analysis(
        ifSuccess: { [event.id: .completed(result: $0)] },
        ifFailure: { [event.id: .failed(error: $0)] }
      )
      return AppPhotos(sights: state.sights.merging(delta, uniquingKeysWith: new))
      
    default: return state
    }
  }
}

extension AppPhotos.Status: CustomStringConvertible {
  var description: String {
    switch self {
    case .notStarted: return "not started"
    case .inProgress: return "in progress"
    case let .completed(result): return "completed with \(String(describing: result))"
    case let .failed(error): return "failed due to \(String(describing: error))"
    }
  }
}
