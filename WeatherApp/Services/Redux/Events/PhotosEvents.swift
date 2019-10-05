import Foundation
import struct Result.AnyError

struct DidStartPhotoSearching: AppEvent {
  let id: WoeID
}

struct DidFinishPhotoSearching: AppEvent {
  let id: WoeID
  let result: Result<URL, PhotosAPIError>
}
