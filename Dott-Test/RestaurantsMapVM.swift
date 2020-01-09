//
//  RestaurantsMapVM.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import CoreLocation

class RestaurantsMapVM {
    private let apiClient = FSAPIClient()
    private let locationManager = LocationManager()
    
    init() {
        requestLocationPermissionIfNeeded()
    }
    
    func requestLocationPermissionIfNeeded() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAuthorization()
        default:
            break
        }
    }
}
