//
//  Venue.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

// MARK: - Venue
struct Venue: Codable, Equatable, Hashable {
    let id, name: String
    let location: Location
    let categories: [Category]
    let popularityByGeo: Double?
    let venuePage: Page?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Venue {
    // MARK: - Location
    struct Location: Codable, Equatable {
        let address: String?
        let crossStreet: String?
        let lat, lng: Double
        let labeledLatLngs: [LabeledLatLng]?
        let distance: Int?
        let postalCode, cc, city, state: String?
        let country: String?
        let formattedAddress: [String]?
    }

    // MARK: - LabeledLatLng
    struct LabeledLatLng: Codable, Equatable {
        let label: String
        let lat, lng: Double
    }
    
    // MARK: - VenuePage
    struct Page: Codable, Equatable {
        let id: String
    }
    
    // MARK: - Category
    struct Category: Codable, Equatable {
        let id, name, pluralName, shortName: String
        let icon: Icon
        let primary: Bool
    }

    // MARK: - Icon
    struct Icon: Codable, Equatable {
        let iconPrefix: String
        let suffix: String

        enum CodingKeys: String, CodingKey {
            case iconPrefix = "prefix"
            case suffix
        }
    }
}
