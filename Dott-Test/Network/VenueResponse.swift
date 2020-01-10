//
//  VenueResponse.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

// MARK: - VenueResponse
struct VenueResponse: Codable {
    let meta: Meta
    let response: Response
    
    // MARK: - Meta
    struct Meta: Codable {
        let code: Int
        let requestID: String?

        enum CodingKeys: String, CodingKey {
            case code
            case requestID
        }
    }

    // MARK: - Response
    struct Response: Codable {
        let venue: VenueDetails
    }

    // MARK: - Venue
    struct VenueDetails: Codable {
        let id, name: String
        let contact: Contact
        let location: Location
        let canonicalURL: String?
        let categories: [Category]
        let url: String?
        let likes: Likes?
        let rating: Double?
        let venueDescription: String?
        let page: Page?
        let shortURL: String?
        let timeZone: String?
        let hours: Hours?
        let bestPhoto: BestPhoto?

        enum CodingKeys: String, CodingKey {
            case id, name, contact, location
            case canonicalURL
            case categories, url, likes, rating
            case venueDescription
            case page
            case shortURL
            case timeZone, hours, bestPhoto
        }
    }

    // MARK: - BestPhoto
    struct BestPhoto: Codable {
        let id: String
        let createdAt: Int
        let source: Source?
        let bestPhotoPrefix: String?
        let suffix: String?
        let width, height: Int?
        let visibility: String?

        enum CodingKeys: String, CodingKey {
            case id, createdAt, source
            case bestPhotoPrefix
            case suffix, width, height, visibility
        }
    }

    // MARK: - Source
    struct Source: Codable {
        let name: String
        let url: String
    }

    // MARK: - Category
    struct Category: Codable {
        let id, name, pluralName, shortName: String
        let icon: Icon?
        let primary: Bool?
    }

    // MARK: - Icon
    struct Icon: Codable {
        let iconPrefix: String?
        let suffix: String?

        enum CodingKeys: String, CodingKey {
            case iconPrefix
            case suffix
        }
    }

    // MARK: - Contact
    struct Contact: Codable {
        let phone, formattedPhone, twitter, instagram: String?
        let facebook, facebookUsername, facebookName: String?
    }

    // MARK: - Hours
    struct Hours: Codable {
        let status: String?
        let isOpen, isLocalHoliday: Bool?
        let timeframes: [Timeframe]?
    }

    // MARK: - Timeframe
    struct Timeframe: Codable {
        let days: String?
        let includesToday: Bool?
        let timeframeOpen: [Open]?

        enum CodingKeys: String, CodingKey {
            case days, includesToday
            case timeframeOpen
        }
    }

    // MARK: - Open
    struct Open: Codable {
        let renderedTime: String?
    }

    // MARK: - Likes
    struct Likes: Codable {
        let count: Int
        let summary: String
    }

    // MARK: - Location
    struct Location: Codable {
        let address, crossStreet: String?
        let lat, lng: Double
        let postalCode, cc, city, state: String?
        let country: String?
        let formattedAddress: [String]?
    }

    // MARK: - Page
    struct Page: Codable {
        let pageInfo: PageInfo
    }

    // MARK: - PageInfo
    struct PageInfo: Codable {
        let pageInfoDescription: String
        let banner: String

        enum CodingKeys: String, CodingKey {
            case pageInfoDescription
            case banner
        }
    }
}
