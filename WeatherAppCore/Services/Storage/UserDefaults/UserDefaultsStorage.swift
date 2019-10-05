import Foundation

final class UserDefaultsStorage: UserDefaultsStorageProtocol {

  struct Reader<T> {
    let store: (T) -> ()
    let retrieve: () -> (T?)
    let remove: () -> ()
  }
  
  let selectedCities: Reader<[Int]> = .init(
    store: { list in  UserDefaults.standard.set(list, forKey: "selectedCities")},
    retrieve: { UserDefaults.standard.array(forKey: "selectedCities") as? [Int] } ,
    remove: { UserDefaults.standard.removeObject(forKey: "selectedCities") }
  )
}
