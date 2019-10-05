import WeatherAppCore
import WeatherAppShared
import ReactiveSwift
import struct Result.AnyError

protocol SearchViewModelProtocol: BaseViewModelProtocol {
  var search: Action<String?, (), AnyError> { get }
  var back: Action<(), (), Never> { get }
  var results: SignalProducer<[SearchResultViewModel], AnyError> { get }
}

class SearchViewModel: BaseViewModel, SearchViewModelProtocol {
  
  var back: Action<(), (), Never> {
    return .init(weakExecute: weakify(SearchViewModel.backProducer, object: self))
  }
  
  var search: Action<String?, (), AnyError> {
    return .init(weakExecute: weakify(SearchViewModel.searchProducer, object: self, default: .never))
  }
  
  var results: SignalProducer<[SearchResultViewModel], AnyError> {
    return store.producer
      .map(\AppState.searching)
      .attemptMap { searching in
        switch searching {
        case let .success(result): return result
          .filter(weakify(SearchViewModel.skipAlreadySelected, object: self, default: false))
          .compactMap(weakify(SearchViewModel.makeCellViewModel, object: self, default: nil))
        case .none, .searching: return []
        case let .error(value): throw value
        }
    }.mapError(AnyError.init)
  }
}

private typealias ProdicerActions = SearchViewModel
private extension ProdicerActions {
  func searchProducer(_ named: String?) -> SignalProducer<(), AnyError> {
    guard let named = named else { return .never }
    store.consume(event: BeginSearching(text: named))
    return .empty
  }
  
  func backProducer() -> SignalProducer<(), Never> {
    store.consume(event: CancelSearch())
    router.perform(route: .dismiss)
    return .empty
  }
}

private typealias Mapping = SearchViewModel
private extension Mapping {
  func skipAlreadySelected(result: SearchResult) -> Bool {
    return store.value.weather.locations
      .map { $0.value }
      .contains(result.id)
      == false
  }
  
  func makeCellViewModel(from model: SearchResult) -> SearchResultViewModel {
    return SearchResultViewModel(
      searchResult: model,
      select: Action {
        self.router.perform(route: .dismiss)
        self.store.consume(event: SelectLocation(id: WoeID(value: model.id)))
        return .empty
      }
    )
  }
}
