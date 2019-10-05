import Foundation
import ReactiveSwift
import struct Result.AnyError

public extension Action {
  public convenience init<P: PropertyProtocol>(enabledIf isEnabled: P,
                                               weakExecute: @escaping (Input) -> SignalProducer<Output, Error>?) where P.Value == Bool {
    self.init(state: isEnabled, enabledIf: { $0 }, execute: { return weakExecute($1) ?? .empty })
  }
  public convenience init(weakExecute: @escaping (Input) -> SignalProducer<Output, Error>?) {
    self.init(execute: { return weakExecute($0) ?? .empty })
  }
}
