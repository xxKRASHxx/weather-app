import ReactiveSwift

extension QueueScheduler {
  static let service = QueueScheduler(
    qos: .default,
    name: "com.service.queue",
    targeting: DispatchQueue(label: "com.service.queue")
  )
}
