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

class RestaurantsMapVM {
    private let apiClient = FSAPIClient()
    private let locationManager = LocationManager()
    private var model = RestaurantsMapModel()
    
    private var cancellables: Set<AnyCancellable> = []
        
    init() {
        requestLocationPermissionIfNeeded()
        subscribeToPermissionChanges()
    }
    
    //MARK:- Location Manager Helper Methods
    func requestLocationPermissionIfNeeded() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAuthorization()
        default:
            break
        }
    }
    
    var currentLocation: CLLocation? {
        return locationManager.currentLocation
    }
    
    var shouldShowPermissionError: Bool {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            return true
        default:
            return false
        }
    }
    
    var locationPermissionUndetermined: Bool {
        return locationManager.authorizationStatus == .notDetermined
    }
    
    //MARK:- Helpers for View
    func allRestaurants() -> Set<Venue> {
        return model.venues
    }
    
    //MARK:- Bindings
    private func subscribeToPermissionChanges() {
        locationManager.$authorizationStatus
            .sink { [weak self] (authorizationStatus) in
            guard let self = self else {
                return
            }
            
            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                break
            case .notDetermined:
                self.requestLocationPermissionIfNeeded()
            case .denied, .restricted:
                break
            @unknown default:
                break
            }
        }
        .store(in: &cancellables)
    }
    
    //MARK:- Network Methods
    private func downloadRestaurants(for coordinates: CLLocationCoordinate2D, radius: Int = 3000) {
        let restaurantsRequest = ExploreVenuesRequest(serviceConfig: .defaultConfig,
                                                      section: .food,
                                                      radius: radius,
                                                      latitude: Float(coordinates.latitude),
                                                      longitude: Float(coordinates.longitude))
        
        let backgroundQueue = DispatchQueue.global(qos: .default)
        
        apiClient.send(request: restaurantsRequest)
        .receive(on: backgroundQueue)
        .replaceError(with: ExploreVenuesResponse.empty)
        .sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .finished:
                break
            }
        }) { (response) in
            guard let groups = response.response?.groups else {
                return
            }
            
            let allVenues = (groups.map{ group -> [Venue] in
                return group.items.compactMap({ $0.venue })
            })
            .joined()
            
            self.model.venues.formUnion(allVenues)
        }
        .store(in: &cancellables)
    }
    
    func downloadRestaurantsForCurrentLocation() {
        guard let coordinates = locationManager.currentCoordinates else {
            return
        }
        
        downloadRestaurants(for: coordinates, radius: 3000)
    }
    
    func changedPositionFor(camera: MKMapView) {
        let center = camera.centerCoordinate
        
        //The radius is calculated by multiplying the degrees by 111,000. Each degree of latitude is approximately 69 miles (111 kilometers) apart.
        let radiusInDegrees = (camera.region.span.longitudeDelta + camera.region.span.latitudeDelta) / 2
        let radius = Int(radiusInDegrees * 111 * 1000)
        
        //We ignore the request if the radius of the map is more than 5000 metres.
        if radius > 5000 {
            return
        }
        
        downloadRestaurants(for: center, radius: radius)
    }
    
    //MARK:- Publishers
    func modelChangedPublisher() -> AnyPublisher<Set<Venue>, Never> {
        return model.modelChangedPublisher.eraseToAnyPublisher()
    }
    
    func permissionChangedPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return locationManager.$authorizationStatus.eraseToAnyPublisher()
    }
    
    func locationChangedPublisher() -> AnyPublisher<CLLocation?, Never> {
        return locationManager.$currentLocation.eraseToAnyPublisher()
    }
}
