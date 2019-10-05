// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation


enum AnyEvent: Codable {
  case beginSearching(BeginSearching)
  case beginUpdateCurrentWeather(BeginUpdateCurrentWeather)
  case beginUpdateWeather(BeginUpdateWeather)
  case cancelSearch(CancelSearch)
  case deselectLocations(DeselectLocations)
  case didChangeLocationPermission(DidChangeLocationPermission)
  case didEndSearch(DidEndSearch)
  case didFinishPhotoSearching(DidFinishPhotoSearching)
  case didRetrieveSelectedIDs(DidRetrieveSelectedIDs)
  case didStartPhotoSearching(DidStartPhotoSearching)
  case didStoreSelectedIDs(DidStoreSelectedIDs)
  case didUpdateCurrentWeather(DidUpdateCurrentWeather)
  case didUpdateLocation(DidUpdateLocation)
  case didUpdateWeather(DidUpdateWeather)
  case requestUpdateLocation(RequestUpdateLocation)
  case selectLocation(SelectLocation)
  case updateLocation(UpdateLocation)

  init(_ event: AppEvent) {
    switch event {
    case let event as BeginSearching: self = .beginSearching(event)
    case let event as BeginUpdateCurrentWeather: self = .beginUpdateCurrentWeather(event)
    case let event as BeginUpdateWeather: self = .beginUpdateWeather(event)
    case let event as CancelSearch: self = .cancelSearch(event)
    case let event as DeselectLocations: self = .deselectLocations(event)
    case let event as DidChangeLocationPermission: self = .didChangeLocationPermission(event)
    case let event as DidEndSearch: self = .didEndSearch(event)
    case let event as DidFinishPhotoSearching: self = .didFinishPhotoSearching(event)
    case let event as DidRetrieveSelectedIDs: self = .didRetrieveSelectedIDs(event)
    case let event as DidStartPhotoSearching: self = .didStartPhotoSearching(event)
    case let event as DidStoreSelectedIDs: self = .didStoreSelectedIDs(event)
    case let event as DidUpdateCurrentWeather: self = .didUpdateCurrentWeather(event)
    case let event as DidUpdateLocation: self = .didUpdateLocation(event)
    case let event as DidUpdateWeather: self = .didUpdateWeather(event)
    case let event as RequestUpdateLocation: self = .requestUpdateLocation(event)
    case let event as SelectLocation: self = .selectLocation(event)
    case let event as UpdateLocation: self = .updateLocation(event)
    default: fatalError("Unexpected event")
    }
  }

  var event: AppEvent {
    switch self {
    case let .beginSearching(event): return event
    case let .beginUpdateCurrentWeather(event): return event
    case let .beginUpdateWeather(event): return event
    case let .cancelSearch(event): return event
    case let .deselectLocations(event): return event
    case let .didChangeLocationPermission(event): return event
    case let .didEndSearch(event): return event
    case let .didFinishPhotoSearching(event): return event
    case let .didRetrieveSelectedIDs(event): return event
    case let .didStartPhotoSearching(event): return event
    case let .didStoreSelectedIDs(event): return event
    case let .didUpdateCurrentWeather(event): return event
    case let .didUpdateLocation(event): return event
    case let .didUpdateWeather(event): return event
    case let .requestUpdateLocation(event): return event
    case let .selectLocation(event): return event
    case let .updateLocation(event): return event
    }
  }

  enum Keys: CodingKey {
    case type, event
  }

  enum EventType: String, Codable {
    case beginSearching
    case beginUpdateCurrentWeather
    case beginUpdateWeather
    case cancelSearch
    case deselectLocations
    case didChangeLocationPermission
    case didEndSearch
    case didFinishPhotoSearching
    case didRetrieveSelectedIDs
    case didStartPhotoSearching
    case didStoreSelectedIDs
    case didUpdateCurrentWeather
    case didUpdateLocation
    case didUpdateWeather
    case requestUpdateLocation
    case selectLocation
    case updateLocation
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    let type = try container.decode(EventType.self, forKey: .type)
    switch type {
    case .beginSearching: self = .beginSearching(try container.decode(BeginSearching.self, forKey: .event))
    case .beginUpdateCurrentWeather: self = .beginUpdateCurrentWeather(try container.decode(BeginUpdateCurrentWeather.self, forKey: .event))
    case .beginUpdateWeather: self = .beginUpdateWeather(try container.decode(BeginUpdateWeather.self, forKey: .event))
    case .cancelSearch: self = .cancelSearch(try container.decode(CancelSearch.self, forKey: .event))
    case .deselectLocations: self = .deselectLocations(try container.decode(DeselectLocations.self, forKey: .event))
    case .didChangeLocationPermission: self = .didChangeLocationPermission(try container.decode(DidChangeLocationPermission.self, forKey: .event))
    case .didEndSearch: self = .didEndSearch(try container.decode(DidEndSearch.self, forKey: .event))
    case .didFinishPhotoSearching: self = .didFinishPhotoSearching(try container.decode(DidFinishPhotoSearching.self, forKey: .event))
    case .didRetrieveSelectedIDs: self = .didRetrieveSelectedIDs(try container.decode(DidRetrieveSelectedIDs.self, forKey: .event))
    case .didStartPhotoSearching: self = .didStartPhotoSearching(try container.decode(DidStartPhotoSearching.self, forKey: .event))
    case .didStoreSelectedIDs: self = .didStoreSelectedIDs(try container.decode(DidStoreSelectedIDs.self, forKey: .event))
    case .didUpdateCurrentWeather: self = .didUpdateCurrentWeather(try container.decode(DidUpdateCurrentWeather.self, forKey: .event))
    case .didUpdateLocation: self = .didUpdateLocation(try container.decode(DidUpdateLocation.self, forKey: .event))
    case .didUpdateWeather: self = .didUpdateWeather(try container.decode(DidUpdateWeather.self, forKey: .event))
    case .requestUpdateLocation: self = .requestUpdateLocation(try container.decode(RequestUpdateLocation.self, forKey: .event))
    case .selectLocation: self = .selectLocation(try container.decode(SelectLocation.self, forKey: .event))
    case .updateLocation: self = .updateLocation(try container.decode(UpdateLocation.self, forKey: .event))
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    switch self {
    case .beginSearching(let event):
      try container.encode(EventType.beginSearching, forKey: .type)
      try container.encode(event, forKey: .event)
    case .beginUpdateCurrentWeather(let event):
      try container.encode(EventType.beginUpdateCurrentWeather, forKey: .type)
      try container.encode(event, forKey: .event)
    case .beginUpdateWeather(let event):
      try container.encode(EventType.beginUpdateWeather, forKey: .type)
      try container.encode(event, forKey: .event)
    case .cancelSearch(let event):
      try container.encode(EventType.cancelSearch, forKey: .type)
      try container.encode(event, forKey: .event)
    case .deselectLocations(let event):
      try container.encode(EventType.deselectLocations, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didChangeLocationPermission(let event):
      try container.encode(EventType.didChangeLocationPermission, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didEndSearch(let event):
      try container.encode(EventType.didEndSearch, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didFinishPhotoSearching(let event):
      try container.encode(EventType.didFinishPhotoSearching, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didRetrieveSelectedIDs(let event):
      try container.encode(EventType.didRetrieveSelectedIDs, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didStartPhotoSearching(let event):
      try container.encode(EventType.didStartPhotoSearching, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didStoreSelectedIDs(let event):
      try container.encode(EventType.didStoreSelectedIDs, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didUpdateCurrentWeather(let event):
      try container.encode(EventType.didUpdateCurrentWeather, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didUpdateLocation(let event):
      try container.encode(EventType.didUpdateLocation, forKey: .type)
      try container.encode(event, forKey: .event)
    case .didUpdateWeather(let event):
      try container.encode(EventType.didUpdateWeather, forKey: .type)
      try container.encode(event, forKey: .event)
    case .requestUpdateLocation(let event):
      try container.encode(EventType.requestUpdateLocation, forKey: .type)
      try container.encode(event, forKey: .event)
    case .selectLocation(let event):
      try container.encode(EventType.selectLocation, forKey: .type)
      try container.encode(event, forKey: .event)
    case .updateLocation(let event):
      try container.encode(EventType.updateLocation, forKey: .type)
      try container.encode(event, forKey: .event)
    }
  }
}
