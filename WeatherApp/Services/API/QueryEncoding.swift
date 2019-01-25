import Moya
import Alamofire

extension URLEncoding {
  
  static var customQueryString: ParameterEncoding {
    return CustomQueryString()
  }
  
  private struct CustomQueryString: ParameterEncoding {
    
    public func encode(_ urlRequest: Alamofire.URLRequestConvertible, with parameters: Alamofire.Parameters?) throws -> URLRequest {
      
      var urlRequest = try urlRequest.asURLRequest()
      
      guard let parameters = parameters
        else { return urlRequest }
      
      guard urlRequest.url != nil else {
        throw AFError.parameterEncodingFailed(reason: .missingURL)
      }
      
      var components = URLComponents()
      components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
      var query = try components.asURL().relativeString
      query = query.replacingCharacters(in: ...query.startIndex, with: ";")
      
      urlRequest.url = URL(string: "\(urlRequest.url?.absoluteString ?? "")\(query)")
      
      return urlRequest
    }
  }
}
