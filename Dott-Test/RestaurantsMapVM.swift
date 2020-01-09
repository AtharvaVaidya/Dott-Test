//
//  RestaurantsMapVM.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class RestaurantsMapVM: ObservableObject {
    private let apiClient = FSAPIClient()
    private let locationManager = LocationManager()
    @Published private var model = RestaurantsMapModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
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
    
    func allRestaurants() -> Set<Venue> {
        return model.venues
    }
    
    func downloadRestaurants() {
        guard let coordinates = locationManager.currentLocation else {
            return
        }
        
        let restaurantsRequest = ExploreVenuesRequest(serviceConfig: .defaultConfig, latitude: Float(coordinates.latitude), longitude: Float(coordinates.longitude))
        
        let backgroundQueue = DispatchQueue.global(qos: .default)
        
        apiClient.send(request: restaurantsRequest)
        .receive(on: backgroundQueue)
        .sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .finished:
                print("Downloaded all restaurants")
            }
        }) { (response) in
            let allVenues = response.response.groups.map{ group -> [Venue] in
                return group.items.map({ $0.venue })
            }
            .joined()
            
            self.model.venues = Set(allVenues)
        }
        .store(in: &cancellables)
    }
}
