import Foundation
import CoreLocation
import ReactiveSwift
import Result

class LocationService: NSObject, AppStoreAccessable {
  
  static let shared = LocationService()
  
  fileprivate lazy var locationManager: CLLocationManager = self.setupLocationManager()
  
  private override init() {
    super.init()
    setupObserving()
    setupStatus()
  }
  
  private func setupObserving() {
    let locationProducer = self.store.producer
      .map(\AppState.location.availability)
      .skipRepeats()
      .observe(on: QueueScheduler.main)
    locationProducer
      .filter { $0 == .requested }
      .startWithValues { [weak self] _ in self?.locationManager.requestWhenInUseAuthorization() }
    locationProducer
      .filter { $0 == .available }
      .startWithValues { [weak self] _ in self?.store.consume(event: UpdateLocation()) }
    let locationRequestProducer = self.store.producer
      .map { $0.location.deviceLocation }
      .skipRepeats()
      .observe(on: QueueScheduler.main)
    locationRequestProducer
      .filter { $0 == .updating }
      .startWithValues { [weak self] _ in self?.locationManager.startUpdatingLocation() }
    locationRequestProducer
      .filter { $0 != .updating && $0 != .none }
      .startWithValues { [weak self] _ in self?.locationManager.stopUpdatingLocation() }
  }
  
  private func setupLocationManager() -> CLLocationManager {
    let result = CLLocationManager()
    result.delegate = self
    result.desiredAccuracy = kCLLocationAccuracyKilometer
    return result
  }
  
  private func setupStatus() {
    guard CLLocationManager.authorizationStatus() != .notDetermined
      else { return }
    store.consume(event: CLLocationManager.authorizationStatus().appEvent)
  }
}

extension LocationService: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    store.consume(event: status.appEvent)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    store.consume(event: DidUpdateLocation(
      timeStamp: Date().timeIntervalSince1970,
      result: .init(error: AnyError(error))))
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    store.consume(event:
      DidUpdateLocation(
        timeStamp: Date().timeIntervalSince1970,
        result: Result(value: Coordinates2D(
          latitude: location.coordinate.latitude,
          longitude: location.coordinate.longitude))))
  }
}

private extension CLAuthorizationStatus {
  var appEvent: AppEvent {
    switch self {
    case .notDetermined, .restricted, .denied: return DidChangeLocationPermission(access: false)
    case .authorizedWhenInUse, .authorizedAlways: return DidChangeLocationPermission(access: true)
    }
  }
}
