import Result
import ReactiveSwift
import Moya

fileprivate extension PhotosAPIService {
  enum BaseURL {
    static let flickr = URL(string: "https://api.flickr.com/services/rest/")!
  }
  enum Request {
    case photo(city: String, country: String, condition: String)
  }
  enum Authorization {
    static let key = "04f8c9c485b9ee117322e7c273654883"
  }
  
  enum SearchType: Int {
    case safe = 1
    case moderate
    case restricted
  }
  
  enum ContentType: Int {
    case photosOnly = 1
    case screenshotsOnly
    case otherOnly
    case photosAndScreenshots
    case screenshotsAndOther
    case photosAndOther
    case photosScreenshotsAndOther
  }
}

class PhotosAPIService {
  fileprivate lazy var provider = MoyaProvider<Request>()
}

extension PhotosAPIService: PhotosAPIServiceProtocol {
  func photo(woeid: WoeID, city: String, country: String, condition: String)
    -> SignalProducer<Response.PhotoResult.Photos.PhotoInfo, PhotosAPIError> {
      return SignalProducer<Response.PhotoResult, PhotosAPIError>{ observer, lifetime in
        lifetime += self.provider.reactive.request(
          .photo(city: city, country: country, condition: condition))
          .start { [weak self] event in
            defer { observer.sendCompleted() }
            switch event {
            case let .value(response):
              do { observer.send(value: try response.map(Response.PhotoResult.self)) }
              catch { observer.send(error: PhotosAPIError(woeid: woeid, type: .generic(error))) }
            case let .failed(error):
              observer.send(error: PhotosAPIError(woeid: woeid, type: .networking(error)))
            default: break
            }
          }
        }
        .attemptMap { result in
          guard let photo = result.photos.photo.first
            else { return .failure(PhotosAPIError(woeid: woeid, type: .noPhotos)) }
          return .success(photo)
        }
  }
}

extension PhotosAPIService.Request: TargetType {
  
  var baseURL: URL { return PhotosAPIService.BaseURL.flickr }
  
  var path: String { return "" }
  
  var method: Moya.Method { return .get }
  
  var sampleData: Data { return Data() }
  
  var task: Task {
    switch self {
    case let .photo(city, country, condition):
      return .requestParameters(
        parameters: [
          "method": "flickr.photos.search",
          "api_key": PhotosAPIService.Authorization.key,
          "tags": "city",//;view;weather;sight;\(condition)",
          "text": "\(city) \(country) \(condition)",
          "safe_search": PhotosAPIService.SearchType.safe.rawValue,
          "content_type": PhotosAPIService.ContentType.photosOnly.rawValue,
          "per_page": 1,
          "page": 1,
          "format": "json",
          "nojsoncallback": true
        ],
        encoding: URLEncoding.queryString)
    }
  }
  
  var validationType: ValidationType { return .successCodes }
  
  var headers: [String: String]? { return nil }
}
