import Foundation

final class UserDefaultsStorage {

  struct Reader<T> {
    let store: (T) -> ()
    let retrieve: () -> (T?)
    let remove: () -> ()
  }

}
