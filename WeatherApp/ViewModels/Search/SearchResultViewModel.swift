import WeatherAppCore
import ReactiveSwift
import struct Result.AnyError

class SearchResultViewModel: BaseViewModel {
  let searchResult: SearchResult
  let select: Action<(), (), Never>
  
  init(searchResult: SearchResult, select: Action<(), (), Never>) {
    self.searchResult = searchResult
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
