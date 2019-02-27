import ReactiveSwift
import Swinject
import struct Result.AnyError
import enum Result.NoError

protocol MQTTServiceProtocol {
  func publish<T>(in channel: String) -> Action<T, (), AnyError> where T: Encodable
  func subscribe<T>(to channel: String) -> Signal<T, NoError> where T: Decodable
}

protocol MQTTServiceAccessible {
  var mqttService: MQTTServiceProtocol { get }
}

extension MQTTServiceAccessible {
  var mqttService: MQTTServiceProtocol {
    return Container.current.resolve(MQTTServiceProtocol.self)!
  }
}