/// sourcery: AutoInit
public struct WoeID: Codable, Equatable, Hashable {
  public let value: Int

// sourcery:inline:auto:WoeID.AutoInit
    public init(value: Int) { // swiftlint:disable:this line_length
        self.value = value
    }
// sourcery:end
}

extension WoeID {
  static let unknown: WoeID = .init(value: -1)
}
