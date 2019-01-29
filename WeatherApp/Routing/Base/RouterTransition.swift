import UIKit

enum RouteType {
  case root
  case permissions
  case citiesList
  case search
  case forecast(woeid: AppWeather.WoeID)
  case dismiss
}
