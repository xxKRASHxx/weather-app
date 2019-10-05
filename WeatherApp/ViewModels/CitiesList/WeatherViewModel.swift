import ReactiveSwift
import struct Result.AnyError

class WeatherViewModel: BaseViewModel {
  let weather: Weather
  let photo: Property<URL?>
  let isCurrent: Property<Bool>
  let select: Action<(), (), Never>
  
  init(weather: Weather, photo: URL?, isCurrent: Property<Bool>, select: Action<(), (), Never>) {
    self.weather = weather
    self.photo = Property(value: photo)
    self.isCurrent = isCurrent
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
