import Foundation
import Result

struct DidStartPhotoSearching: AppEvent {
  let id: WoeID
}

struct DidFinishPhotoSearching: AppEvent {
  let id: WoeID
  let result: Result<URL, PhotosAPIError>
}
