protocol AutoDecodable: Swift.Decodable {}
protocol AutoEncodable: Swift.Encodable {}
protocol AutoCodable: AutoDecodable, AutoEncodable {}
