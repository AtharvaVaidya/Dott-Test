//
//  GetVenuesResponse.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

// MARK: - ExploreVenuesResponse
struct ExploreVenuesResponse: FSAPIResponse {
    typealias ResponseData = Response
    
    let meta: FSAPIResponseMetadata
    let response: Response?

    // MARK: - Response
    struct Response: Codable {
        let warning: Warning?
        let suggestedRadius: Int?
        let headerLocation, headerFullLocation, headerLocationGranularity: String
        let totalResults: Int
        let groups: [Group]
    }

    // MARK: - Group
    struct Group: Codable {
        let type, name: String
        let items: [GroupItem]
    }

    // MARK: - GroupItem
    struct GroupItem: Codable {
        let venue: Venue
    }

    // MARK: - Ne
    struct Ne: Codable {
        let lat, lng: Double
    }

    // MARK: - Warning
    struct Warning: Codable {
        let text: String
    }
}

extension ExploreVenuesResponse {
    static var empty: ExploreVenuesResponse {
        return ExploreVenuesResponse(meta: FSAPIResponseMetadata(code: 404, requestID: nil), response: nil)
    }
}
