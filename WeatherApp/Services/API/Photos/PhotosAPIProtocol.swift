import ReactiveSwift
import Result
import Swinject
import Moya

struct PhotosAPIError: Error, Codable, Equatable {
  let woeid: WoeID
  let type: ErrorType; enum ErrorType: Codable, Equatable {
    
    static func == (lhs: PhotosAPIError.ErrorType, rhs: PhotosAPIError.ErrorType) -> Bool {
     return false
    }
    
    init(from decoder: Decoder) throws { fatalError("PhotosAPIError.init(from decoder:) unimplemented") }
    func encode(to encoder: Encoder) throws {}
    
    case noPhotos
    case networking(MoyaError)
    case generic(Error)
  }
}

protocol PhotosAPIServiceProtocol {
  func photo(woeid: WoeID, city: String, country: String, condition: String)
    -> SignalProducer<Response.PhotoResult.Photos.PhotoInfo, PhotosAPIError>
}

protocol PhotosAPIAccessable {
  var photosAPI : PhotosAPIServiceProtocol { get }
}

extension PhotosAPIAccessable {
  var photosAPI : PhotosAPIServiceProtocol {
    return Container.current.resolve(PhotosAPIServiceProtocol.self)!
  }
}

