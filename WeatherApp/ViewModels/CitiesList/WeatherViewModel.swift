import ReactiveSwift
import Result

class WeatherViewModel: BaseViewModel {
  let weather: Weather
  let select: Action<(), (), NoError>
  
  init(weather: Weather, select: Action<(), (), NoError>) {
    self.weather = weather
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
