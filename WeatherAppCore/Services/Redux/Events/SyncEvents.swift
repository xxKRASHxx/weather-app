struct DidStoreSelectedIDs: AppEvent {}

public struct DidRetrieveSelectedIDs: AppEvent {
  let selected: [Int]
}
