//
//  RestaurantModel.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class RestaurantDetailModel {
    typealias VenueDetails = VenueResponse.VenueDetails
    
    let venue: Venue
    @Published var details: VenueDetails?
    
    init(venue: Venue, details: VenueDetails? = nil) {
        self.venue = venue
        self.details = details
    }
}
