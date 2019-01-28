struct DidStoreSelectedIDs: AppEvent {}

struct DidRetrieveSelectedIDs: AppEvent {
  let selected: [Int]
}
