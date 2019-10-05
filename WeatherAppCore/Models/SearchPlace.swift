public struct SearchResult: Codable, Equatable {
  public let id: Int
  public let location: Coordinates2D
  public let city: String
  public let country: String
  public let qualifiedName: String
}
