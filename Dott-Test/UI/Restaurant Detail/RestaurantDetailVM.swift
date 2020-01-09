//
//  RestaurantDetailVM.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class RestaurantDetailVM {
    private let restaurant: Venue
    
    private let headers: [String] = ["Name", "Address", "Categories"]
    
    init(restaurant: Venue) {
        self.restaurant = restaurant
    }
    
    var numberOfSections: Int {
        return headers.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func header(for section: Int) -> String {
        guard headers.indices.contains(section) else {
            return ""
        }
        
        return headers[section]
    }
    
    func valueForCell(at indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return restaurant.name
        case 1:
            return restaurant.location.address ?? ""
        case 2:
            return restaurant.categories.map({ $0.name }).joined(separator: ", ")
        default:
            return ""
        }
    }
}
