struct SearchResult: Codable, Equatable {
  let id: Int
  let location: Coordinates2D
  let city: String
  let country: String
  let qualifiedName: String
}
