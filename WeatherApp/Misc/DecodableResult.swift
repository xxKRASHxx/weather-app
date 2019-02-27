import Result

extension Result: Codable where Value: Codable, Error: Codable {
  
  private enum Keys: String, CodingKey {
    case type = "type"
  }
  
  enum ResultType: String, Codable {
    case value = "valiue"
    case error = "error"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    switch try container.decode(ResultType.self, forKey: .type) {
    case .value: self = try Result(value: Value(from: decoder))
    case .error: self = try Result(error: Error(from: decoder))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    switch self {
    case let .success(value):
      try container.encode(ResultType.value.rawValue, forKey: .type)
      try value.encode(to: encoder)
    case let .failure(error):
      try container.encode(ResultType.error.rawValue, forKey: .type)
      try error.encode(to: encoder)
    }
  }
}

extension AnyError: Codable {
  
  struct DecodedError: Error {}
  
  private enum Keys: String, CodingKey {
    case error = "error"
  }
  
  public init(from decoder: Decoder) throws {
    self = .error(from: DecodedError())
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    try container.encode(errorDescription, forKey: .error)
  }
}

extension AnyError: Equatable {
  public static func == (lhs: AnyError, rhs: AnyError) -> Bool {
    return lhs.errorDescription == rhs.errorDescription
  }
}
