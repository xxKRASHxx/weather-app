struct WoeID: Codable, Equatable, Hashable {
  let value: Int
  
  static let unknown: WoeID = .init(value: -1)
}
