// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension AppLocation.DeviceLocation {

    enum CodingKeys: String, CodingKey {
        case none
        case updating
        case success
        case error
        case location
        case timestamp
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .none:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .none)
        case .updating:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .updating)
        case let .success(location, timestamp):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .success)
            try associatedValues.encode(location, forKey: .location)
            try associatedValues.encode(timestamp, forKey: .timestamp)
        case let .error(value):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            try associatedValues.encode(value, forKey: .value)
        }
    }

}

extension AppPhotos.Status {

    enum CodingKeys: String, CodingKey {
        case notStarted
        case inProgress
        case completed
        case failed
        case result
        case error
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .notStarted:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .notStarted)
        case .inProgress:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .inProgress)
        case let .completed(result):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .completed)
            try associatedValues.encode(result, forKey: .result)
        case let .failed(error):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .failed)
            try associatedValues.encode(error, forKey: .error)
        }
    }

}

extension AppSync {

    enum CodingKeys: String, CodingKey {
        case notSynced
        case synced
        case needs
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .notSynced(needs):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .notSynced)
            try associatedValues.encode(needs, forKey: .needs)
        case .synced:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .synced)
        }
    }

}

extension WeatherRequestState {

    enum CodingKeys: String, CodingKey {
        case selected
        case updating
        case success
        case error
        case current
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .selected:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .selected)
        case .updating:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .updating)
        case let .success(current):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .success)
            try associatedValues.encode(current, forKey: .current)
        case let .error(value):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            try associatedValues.encode(value, forKey: .value)
        }
    }

}
