//
//  LocationDataManager.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 22.02.2024.
//

import CoreLocation

class LocationDataManager: NSObject {
    static let shared = LocationDataManager()
    
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    
    
    private override init() {
        super.init()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.delegate = self
                self?.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
}
