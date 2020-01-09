//
//  RestaurantAnnotationView.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    let restaurant: Venue
    
    static let identifier = "RestaurantAnnotationView"
    
    var coordinate: CLLocationCoordinate2D {
        return restaurant.location.coordinates
    }
    
    init(restaurant: Venue) {
        self.restaurant = restaurant
        
        super.init()
    }
    
    var subtitle: String? {
        return restaurant.name
    }
}

extension Venue.Location {
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
