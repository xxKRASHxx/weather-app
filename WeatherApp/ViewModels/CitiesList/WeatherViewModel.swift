import ReactiveSwift
import Result

class WeatherViewModel: BaseViewModel {
  let weather: Weather
  let photo: Property<URL?>
  let isCurrent: Property<Bool>
  let select: Action<(), (), NoError>
  
  init(weather: Weather, photo: URL?, isCurrent: Property<Bool>, select: Action<(), (), NoError>) {
    self.weather = weather
    self.photo = Property(value: photo)
    self.isCurrent = isCurrent
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
