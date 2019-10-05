import Foundation
import Moya
import OAuthSwift

struct AuthPlugin: PluginType {
  
  let credentials: Credentials; struct Credentials {
    let key: String
    let secret: String
  }
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    return try! OAuthSwiftClient(consumerKey: credentials.key, consumerSecret: credentials.secret)
      .makeRequest(request)
      .makeRequest()
  }
}
