import Foundation
import struct Result.AnyError

/// sourcery: AutoInit
public struct CancelSearch: AppEvent {
// sourcery:inline:auto:CancelSearch.AutoInit
    public init() { // swiftlint:disable:this line_length
    }
// sourcery:end
}

/// sourcery: AutoInit
public struct BeginSearching: AppEvent {
  public let text: String

// sourcery:inline:auto:BeginSearching.AutoInit
    public init(text: String) { // swiftlint:disable:this line_length
        self.text = text
    }
// sourcery:end
}
