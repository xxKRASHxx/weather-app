import SwiftUI
import WeatherAppCore

struct SearchListRowPresenter: ItemPresenter {
  
  let item: WoeID
  let content: () -> SearchListRow
  
  
  func map(
    state: AppState,
    dispatch: @escaping (AppEvent) -> Void)
    -> SearchListRow.Props { .init(
      id: String(describing: item.value),
      title: state.searching.result?.value?
        .first { $0.id == item }?.qualifiedName ?? "",
      select: { dispatch(SelectLocation(id: self.item)) })
  }
}
