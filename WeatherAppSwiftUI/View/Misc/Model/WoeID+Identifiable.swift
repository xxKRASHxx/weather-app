import WeatherAppCore

extension WoeID: Identifiable {
  public var id: String { String(describing: value) }
}
