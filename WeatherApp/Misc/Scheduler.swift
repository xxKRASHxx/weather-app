import ReactiveSwift

extension QueueScheduler {
  static let service = QueueScheduler(qos: .utility, name: "Service_queue", targeting: .main)
}
