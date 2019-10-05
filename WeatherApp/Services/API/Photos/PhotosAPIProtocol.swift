import ReactiveSwift
import struct Result.AnyError
import Swinject
import Moya

enum PhotosAPIError: Error, Codable, Equatable {
  
  static func == (lhs: PhotosAPIError, rhs: PhotosAPIError) -> Bool {
    return false
  }
  
  init(from decoder: Decoder) throws { fatalError("PhotosAPIError.init(from decoder:) unimplemented") }
  func encode(to encoder: Encoder) throws {}
  
  case noPhotos
  case networking(MoyaError)
  case generic(Error)
}
protocol PhotosAPIServiceProtocol {
  func photo(city: String, country: String, condition: String)
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

