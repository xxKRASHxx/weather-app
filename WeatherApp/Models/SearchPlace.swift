struct SearchResult: Decodable {
  let id: Int
  let location: Location
  let city: String
  let country: String
  let qualifiedName: String
}
