import ReactiveSwift
import Result

class WeatherViewModel: BaseViewModel {
  let weather: Weather
  let photo: Property<URL?>
  let select: Action<(), (), NoError>
  
  init(weather: Weather, photo: URL?, select: Action<(), (), NoError>) {
    self.weather = weather
    self.photo = Property(value: photo)
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
