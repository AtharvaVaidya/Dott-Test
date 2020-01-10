//
//  LocationManager.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    
    var currentCoordinates: CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
    
    @Published var currentLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        startMonitoringLocation()
    }
    
    func requestAuthorization() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func startMonitoringLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startMonitoringLocation()
        case .restricted, .denied, .notDetermined:
            break
        @unknown default:
            startMonitoringLocation()
        }
        
        authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location
    }
}
