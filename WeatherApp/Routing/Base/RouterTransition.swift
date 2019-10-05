import WeatherAppCore

enum RouteType {
  case root
  case permissions
  case citiesList
  case search
  case forecast(woeid: WeatherAppCore.WoeID)
  case dismiss
}
