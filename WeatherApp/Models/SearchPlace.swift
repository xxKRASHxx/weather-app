struct SearchResult: Codable, Equatable {
  let id: Int
  let location: Location
  let city: String
  let country: String
  let qualifiedName: String
}
