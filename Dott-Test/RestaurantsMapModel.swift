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
}
