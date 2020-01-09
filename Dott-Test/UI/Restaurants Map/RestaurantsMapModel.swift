//
//  RestaurantsModel.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import MapKit
import Combine

class RestaurantsMapModel {
    var venues: Set<Venue> = [] {
        didSet {
            modelChangedPublisher.send(venues)
        }
    }
    
    var modelChangedPublisher = PassthroughSubject<Set<Venue>, Never>()
}
