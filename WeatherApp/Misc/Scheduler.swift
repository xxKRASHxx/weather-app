import ReactiveSwift

extension QueueScheduler {
  static let service = QueueScheduler(
    qos: .utility,
    name: "Service_queue",
    targeting: DispatchQueue(label: "com.service.queue")
  )
}
