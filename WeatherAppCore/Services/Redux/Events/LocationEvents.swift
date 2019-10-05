import Foundation
import struct Result.AnyError

/// sourcery: AutoInit
public struct DidChangeLocationPermission: AppEvent {
  let access: Bool

// sourcery:inline:auto:DidChangeLocationPermission.AutoInit
    public init(access: Bool) { // swiftlint:disable:this line_length
        self.access = access
    }
// sourcery:end
}

/// sourcery: AutoInit
public struct RequestUpdateLocation: AppEvent {

// sourcery:inline:auto:RequestUpdateLocation.AutoInit
    public init() { // swiftlint:disable:this line_length
    }
// sourcery:end
}

public struct UpdateLocation: AppEvent {}

public struct DidUpdateLocation: AppEvent {
  let timeStamp: TimeInterval
  let result: Result<Coordinates2D, AnyError>
}
