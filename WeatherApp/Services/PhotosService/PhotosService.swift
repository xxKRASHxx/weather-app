import Swinject
import ReactiveSwift
import Result

class PhotosService: PhotosAPIAccessable, AppStoreAccessable {
  
  static let shared: PhotosService = .init()
  
  private init() {
    setupObserving()
  }
  
  private func setupObserving() {
    observeWoeIDs()
  }
  
  private func observeWoeIDs() {
    
    let unhandled: (([WoeID : WeatherRequestState]) -> [WoeID]) = { locations in locations
      .filter { (key, value) in
        guard case .success = value else { return false }
        return true
      }
      .compactMap { (key, _) in key }
    }
    
    let woeidProducer = store.producer
      .map(\AppState.weather.locationsMap)
      .map(unhandled)
      .flatMap(.latest, SignalProducer<WoeID, NoError>.init)
      .filter { self.store.value.photos.sights[$0] == .notStarted || self.store.value.photos.sights[$0] == .none}
    
    let photosProducer = woeidProducer
      .map(weatherFromWoeID)
      .map(photoRequestParams)
      .flatMap(.merge, photosAPI.photo)
    
    woeidProducer
      .map(DidStartPhotoSearching.init)
      .flatMap(.merge, SignalProducer<DidStartPhotoSearching, NoError>.init)
      .observe(on: QueueScheduler.main)
      .startWithValues(store.consume)
    
    SignalProducer.zip(
      woeidProducer.flatMap(.latest, SignalProducer<WoeID, PhotosAPIError>.init),
      photosProducer)
      .observe(on: QueueScheduler.main)
      .map { (id, info) in ( id, Response.PhotoResult.Photos.PhotoInfo.url(info)) }
      .startWithResult(consumePhotosResult)
  }
}

private extension Response.PhotoResult.Photos.PhotoInfo {
  static func url(_ response: Response.PhotoResult.Photos.PhotoInfo) -> URL {
    return URL(string: "https://farm\(response.farm).staticflickr.com/\(response.server)/\(response.id)_\(response.secret).jpg")!
  }
}

private extension PhotosService {
  
  func consumePhotosResult(_ result: Result<(WoeID, URL), PhotosAPIError>) {
    store.consume(event: result.analysis(
      ifSuccess: { (woeid, url) in DidFinishPhotoSearching(id: woeid, result: .init(value: url)) },
      ifFailure: { (error) in DidFinishPhotoSearching(id: error.woeid, result: .init(error: error)) }
    ))
  }
  
  func photoRequestParams(from weather: Weather)
    -> (woeid: WoeID, city: String, country: String, condition: String) {
      return (
        weather.location.woeid,
        weather.location.city,
        weather.location.country,
        weather.now.condition.text
      )
  }
  
  func weatherFromWoeID(woeid: WoeID) -> Weather {
    return store.value.weather.locationsMap[woeid]!.weather!
  }
}
