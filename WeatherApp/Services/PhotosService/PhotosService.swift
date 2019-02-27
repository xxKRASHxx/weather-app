import Swinject
import ReactiveSwift
import Result

class PhotosService: PhotosAPIAccessable, AppStoreAccessable {
  
  static let shared: PhotosService = .init()
  
  private init() {
    setupObserving()
  }
  
  private func setupObserving() {
    
    let unhandled: (([WoeID : WeatherRequestState]) -> [WoeID]) = { locations in locations
      .filter { (key, value) in
        guard case .success = value else { return false }
        return true
      }
      .compactMap { (key, _) in key }
    }
    
    let needsDownload: ((WoeID) -> Bool) = {
      self.store.value.photos.sights[$0] == .notStarted || self.store.value.photos.sights[$0] == .none
    }
    
    let woeidProducer = store.producer
      .map(\AppState.weather.locationsMap)
      .map(unhandled)
      .flatMap(.latest, SignalProducer<WoeID, NoError>.init)
      .filter(needsDownload)
      
    woeidProducer
      .map(keepSource(weatherFromWoeID))
      .map(transformResult(photoRequestParams))
      .flatMap(.merge, transformResult(photosAPI.photo, consumePhotosError))
      .map(transformResult(Response.PhotoResult.Photos.PhotoInfo.url))
      .startWithValues(consumePhotosValue)
    
    woeidProducer
      .map(DidStartPhotoSearching.init)
      .flatMap(.merge, SignalProducer<DidStartPhotoSearching, NoError>.init)
      .startWithValues(store.consume)
  }
}

private extension PhotosService {
  
  func consumePhotosValue(tuple: SourceKeptTuple<WoeID, URL>) {
    store.consume(event: DidFinishPhotoSearching(id: tuple.source, result: .init(value: tuple.result)))
  }
  
  func consumePhotosError(error: PhotosAPIError, tuple: SourceKeptTuple<WoeID, Any>) {
    store.consume(event: DidFinishPhotoSearching(id: tuple.source, result: .init(error: error)))
  }
  
  func photoRequestParams(from weather: Weather)
    -> (city: String, country: String, condition: String) {
      return (
        weather.location.city,
        weather.location.country,
        weather.now.condition.text
      )
  }
  
  func weatherFromWoeID(woeid: WoeID) -> Weather {
    return store.value.weather.locationsMap[woeid]!.weather!
  }
}

private extension Response.PhotoResult.Photos.PhotoInfo {
  static func url(_ response: Response.PhotoResult.Photos.PhotoInfo) -> URL {
    return URL(string: "https://farm\(response.farm).staticflickr.com/\(response.server)/\(response.id)_\(response.secret).jpg")!
  }
}
