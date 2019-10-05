struct WoeID: Codable, Equatable, Hashable {
  let value: Int
}

extension WoeID {
  static let unknown: WoeID = .init(value: -1)
}
