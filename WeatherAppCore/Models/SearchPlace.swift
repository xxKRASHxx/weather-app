public struct SearchResult: Codable, Equatable {
  public let id: WoeID
  public let location: Coordinates2D
  public let city: String
  public let country: String
  public let qualifiedName: String
}
