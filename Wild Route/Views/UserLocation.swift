import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
    }
    func start() {
        self.locationManager.startUpdatingLocation()
    }
    func status() -> CLAuthorizationStatus {
        return self.locationManager.authorizationStatus
    }
}



extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        print(#function, location)
        self.location = location
    }
}
