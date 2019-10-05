import Foundation
import struct Result.AnyError

public struct DidStartPhotoSearching: AppEvent {
  let id: WoeID
}

public struct DidFinishPhotoSearching: AppEvent {
  let id: WoeID
  let result: Result<URL, PhotosAPIError>
}
