import Result

struct DidChangeLocationPermission: AppEvent {
  let access: Bool
}

struct RequestUpdateLocation: AppEvent {}

struct UpdateLocation: AppEvent {}

struct DidUpdateLocation: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Location, AnyError>
}
