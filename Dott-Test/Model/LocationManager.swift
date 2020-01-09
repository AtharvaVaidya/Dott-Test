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
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var currentCoordinates: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    @Published var currentLocation: CLLocation?
    
    private var locationUpdatePublisher = PassthroughSubject<CLLocation?, Never>()
    
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
    
    func subscribeToLocationChanges<T: Subscriber>(subscriber: T) where T.Input == CLLocation?, T.Failure == Never {
        locationUpdatePublisher.subscribe(subscriber)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location
    }    
}
