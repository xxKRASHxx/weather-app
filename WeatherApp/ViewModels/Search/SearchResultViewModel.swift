import ReactiveSwift
import Result

class SearchResultViewModel: BaseViewModel {
  let searchResult: SearchResult
  let select: Action<(), (), NoError>
  
  init(searchResult: SearchResult, select: Action<(), (), NoError>) {
    self.searchResult = searchResult
    self.select = select
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
}
