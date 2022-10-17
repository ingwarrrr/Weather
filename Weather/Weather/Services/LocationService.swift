//
//  LocationService.swift
//  Weather
//
//  Created by Igor on 16.10.2022.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject {
    let locationService = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        locationService.delegate = self
    }
    
    func requestLocation() {
        isLoading = true
        locationService.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location: \(error.localizedDescription)")
        isLoading = false
    }
}
