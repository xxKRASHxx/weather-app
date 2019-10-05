import ReactiveSwift
import struct Result.AnyError
import Swinject
import Moya

public enum PhotosAPIError: Error, Codable, Equatable {
  
  public static func == (lhs: PhotosAPIError, rhs: PhotosAPIError) -> Bool {
    return false
  }
  
  public init(from decoder: Decoder) throws { fatalError("PhotosAPIError.init(from decoder:) unimplemented") }
  public func encode(to encoder: Encoder) throws {}
  
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
    return Container.default.resolver.resolve(PhotosAPIServiceProtocol.self)!
  }
}

