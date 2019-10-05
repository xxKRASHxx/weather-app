public protocol AutoDecodable: Swift.Decodable {}
public protocol AutoEncodable: Swift.Encodable {}
public protocol AutoCodable: AutoDecodable, AutoEncodable {}
