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
    
    init(restaurant: Venue) {
        self.restaurant = restaurant
    }
    
    let numberOfSections = 3
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func titleForCell(at indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return "Name"
        case 1:
            return "Address"
        case 2:
            return "Categories"
        default:
            return ""
        }
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
