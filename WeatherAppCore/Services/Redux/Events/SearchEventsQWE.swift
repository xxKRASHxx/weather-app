import Foundation
import struct Result.AnyError

public struct DidEndSearch: AppEvent {
  public let timeStamp: TimeInterval
  public let result: Result<[SearchResult], AnyError>
}

/// sourcery: AutoInit
public struct SelectLocation: AppEvent {
  public let id: WoeID

// sourcery:inline:auto:SelectLocation.AutoInit
    public init(id: WoeID) { // swiftlint:disable:this line_length
        self.id = id
    }
// sourcery:end
}

public struct DeselectLocations: AppEvent {
  public let id: WoeID
  
  public init(id: WoeID) { // swiftlint:disable:this line_length
      self.id = id
  }
}
