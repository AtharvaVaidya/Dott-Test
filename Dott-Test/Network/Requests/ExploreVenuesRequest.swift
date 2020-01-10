//
//  GetVenuesRequest.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class ExploreVenuesRequest: FSAPIRequest {
    typealias Response = ExploreVenuesResponse
    
    static let authenticationType: FSRequestAuthenticationType = .userless
    
    let endPoint: APIEndPoint = APIEndPoints.Venues.explore
    let serviceConfig: APIServiceConfig
    
    private let latitude: Float
    private let longitude: Float
    
    let section: Section?
    let radius: Int
    
    private enum QueryItems: String {
        case ll = "ll"
        case clientID = "client_id"
        case clientSecret = "client_secret"
        ///v is the version in the format YYYYMMDD
        case v = "v"
        case section = "section"
        case radius = "radius"
    }
    
    enum Section: String {
        case food
        case drinks
        case coffee
        case shops
        case arts
        case outdoors
        case sights
        case trending
        case nextVenues
    }
    
    init(serviceConfig: APIServiceConfig,
         section: Section,
         radius: Int,
         latitude: Float,
         longitude: Float) {
        self.serviceConfig = serviceConfig
        self.section = section
        self.radius = radius
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func constructURLQueryItems() -> [URLQueryItem] {
        let coordinates = "\(latitude),\(longitude)"
        
        let apiKey = FSAPICredentials.apiKey
        let apiSecret = FSAPICredentials.apiSecret
        
        let version = getCurrentVersion()
        
        let coordinatesItem = URLQueryItem(name: QueryItems.ll.rawValue, value: coordinates)
        let clientIDItem = URLQueryItem(name: QueryItems.clientID.rawValue, value: apiKey)
        let clientSecretItem = URLQueryItem(name: QueryItems.clientSecret.rawValue, value: apiSecret)
//        let versionItem = URLQueryItem(name: QueryItems.v.rawValue, value: version)
        let radiusItem = URLQueryItem(name: QueryItems.radius.rawValue, value: "\(radius)")
        
        var items = [coordinatesItem,
                     radiusItem,
                     clientIDItem,
                     clientSecretItem]
//                     versionItem]
        
        if let section = self.section {
            let sectionItem = URLQueryItem(name: QueryItems.section.rawValue, value: section.rawValue)
            items.append(sectionItem)
        }
        
        return items
    }
    
    func signed() -> URLRequest {
        let queryItems = constructURLQueryItems()
        
        guard let requestURL = requestURL(queryItems: queryItems) else {
            return URLRequest(url: serviceConfig.url, cachePolicy: serviceConfig.cachePolicy, timeoutInterval: serviceConfig.timeout)
        }
        
        let request = URLRequest(url: requestURL, cachePolicy: serviceConfig.cachePolicy, timeoutInterval: serviceConfig.timeout)
        
        return request
    }
    
    func requestURL(queryItems: [URLQueryItem]) -> URL? {
        let baseURL = serviceConfig.url.absoluteString
        let endPointString = endPoint.construct()
        let urlString = baseURL + endPointString
        
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return url
    }
    
    func getCurrentVersion() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMDD"
        
        return dateFormatter.string(from: Date())
    }
}
