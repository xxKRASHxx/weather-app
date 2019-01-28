import Swinject

protocol UserDefaultsStorageProtocol {
  var selectedCities: UserDefaultsStorage.Reader<[Int]> { get }
}

protocol UserDefaultsAccessable {
  var userDefaultsStorage : UserDefaultsStorageProtocol { get }
}

extension UserDefaultsAccessable {
  var userDefaultsStorage : UserDefaultsStorageProtocol {
    return Container.current.resolve(UserDefaultsStorageProtocol.self)!
  }
}
