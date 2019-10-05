import Foundation
import ReactiveSwift
import CocoaMQTT
import Result

class MQTTService {
  
  private let client: CocoaMQTT = .defaultClient { client in
    client.logLevel = .error
    client.connect()
  }
  
  private lazy var messages: Signal<(CocoaMQTTMessage, UInt16), NoError> = {
    return Signal { [weak self] observer, lifetime in
      guard let self = self else { return }
      self.client.didPublishMessage = { _, message, handle in
        observer.send(value: (message, handle))
      }
    }
  } ()
  
  private lazy var state: Signal<CocoaMQTTConnState, NoError> = {
    return Signal { [weak self] observer, lifetime in
      guard let self = self else { return }
      self.client.didChangeState = { _, state in
        observer.send(value: state)
      }
    }
  } ()
}

extension MQTTService: MQTTServiceProtocol {
  func publish<T>(in channel: String)
    -> Action<T, (), AnyError>
    where T: Encodable
  {
    return Action(execute: publishClosure(in: channel))
  }
  
  func subscribe<T>(to channel: String) -> Signal<T, NoError> where T : Decodable {
    fatalError()
  }
}

private typealias ActionClosures = MQTTService
private extension ActionClosures {
  func publishClosure<T>(in channel: String) ->
    (T) -> SignalProducer<(), AnyError>
    where T: Encodable
  {
    return { [weak self] message in
      
      var data: Data
      
      guard let self = self else { return .empty }
      do { data = try JSONEncoder().encode(message) }
      catch { return SignalProducer(error: AnyError(error)) }
      
      self.client.publish(.init(
        topic: channel,
        payload: .init(data)))
      
      return .empty
    }
  }
}


extension CocoaMQTT {
  
  static func defaultClient(_ modifying: (inout CocoaMQTT) -> Void = { _ in }) -> CocoaMQTT {
    var client = CocoaMQTT(clientID: UIDevice.current.identifierForVendor?.uuidString ?? "")
    
    client.autoReconnectTimeInterval = 5
    client.autoReconnect = true
    client.allowUntrustCACertificate = true
    
    modifying(&client)
    
    return client
  }
}
