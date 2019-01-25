import Foundation
import Redux_ReactiveSwift
import Result

struct AppLocation: Encodable, Equatable {
  
  let availability: Availability; enum Availability: AutoEncodable, Equatable {
    case notYetRequested
    case requested
    case notAvailable
    case available
  }
  
  let deviceLocation: DeviceLocation; enum DeviceLocation: AutoEncodable, Equatable {
    case none
    case updating
    case success(location: Location, timestamp: TimeInterval)
    case error(value: AnyError)
  }
}

extension AppLocation: Defaultable {
  static var defaultValue = AppLocation(
    availability: .notYetRequested,
    deviceLocation: .none)
}

extension AppLocation {
  static func reudce(_ state: AppLocation, _ event: AppEvent) -> AppLocation {
    switch event {
    case let event as DidChangeLocationPermission:
      return AppLocation(
        availability: event.access
          ? .available
          : .notAvailable,
        deviceLocation: state.deviceLocation)
    case let event as DidUpdateLocation:
      return AppLocation(
        availability: state.availability,
        deviceLocation: event.result.analysis(
          ifSuccess: { location in
            .success(
              location: location,
              timestamp: event.timeStamp
            )
          },
          ifFailure: { error in
            .error(value: error)
          }))
    case is RequestUpdateLocation:
      return AppLocation(
        availability: .requested,
        deviceLocation: state.deviceLocation)

    case is UpdateLocation:
      return AppLocation(
        availability: state.availability,
        deviceLocation: .updating)
    default: return state
    }
  }
  
  static func trottleLocationUpdates(_ state: AppLocation, _ event: AppEvent) -> AppLocation {
    
    func locationRequest(previous: AppLocation) -> AppLocation {
      guard case .available = previous.availability else { return previous }
      if case .success(_, let timestamp) = previous.deviceLocation {
        if (Date().timeIntervalSince1970 - timestamp < 300) { return previous }
      }
      return AppLocation(
        availability: previous.availability,
        deviceLocation: .updating)
    }
    
    switch event {
    case is RequestUpdateLocation:
      return locationRequest(previous: state)
    default: return state
    }
  }
}

func == (lhs: AppLocation.DeviceLocation, rhs: AppLocation.DeviceLocation) -> Bool {
  switch (lhs, rhs) {
  case (.none, .none), (.updating, .updating):
    return true
  case let (.success(lhs_location, lhs_timestamp), .success(rhs_location, rhs_timestamp)):
    return lhs_location == rhs_location && lhs_timestamp == rhs_timestamp
  case (.none, _), (.updating, _), (.success, _), (.error, _):
    return false
  }
}


extension AppLocation.DeviceLocation {
  var isSuccess: Bool {
    guard case .success = self else { return false }
    return true
  }
}
