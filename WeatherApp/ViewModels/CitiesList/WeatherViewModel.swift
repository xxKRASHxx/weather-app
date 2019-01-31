import ReactiveSwift
import Result

class WeatherViewModel: BaseViewModel {
  let weather: Weather
  let photo: URL?
  let select: Action<(), (), NoError>
  
  init(weather: Weather, photo: URL?, select: Action<(), (), NoError>) {
    self.weather = weather
    self.photo = photo
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
