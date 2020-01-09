//
//  RestaurantsModel.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import MapKit

class RestaurantsMapModel: ObservableObject {
    @Published var venues: Set<Venue> = []
    
    func placemarks() -> [MKPlacemark] {
        return venues.map {
            MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: $0.location.lat, longitude: $0.location.lng))
        }
    }
}
