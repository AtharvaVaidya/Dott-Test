//
//  VenueRequest.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class GetVenueRequest: FSAPIRequest {
    typealias Response = GetVenueResponse

    static let authenticationType: FSRequestAuthenticationType = .userless

    let body: Data?
    let httpMethod: HTTPMethod = .get
    let endPoint: APIEndPoint
    let serviceConfig: APIServiceConfig
        
    private enum QueryItems: String {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        ///v is the version in the format YYYYMMDD
        case v = "v"
    }
    
    init(serviceConfig: APIServiceConfig, body: Data? = nil, eventID: String) {
        self.serviceConfig = serviceConfig
        self.body = body
        self.endPoint = APIEndPoints.Venues.details(eventID: eventID)
    }
    
    func signed() -> URLRequest {
        let queryItems = constructURLQueryItems()
        
        guard let requestURL = requestURL(queryItems: queryItems) else {
            return URLRequest(url: serviceConfig.url, cachePolicy: serviceConfig.cachePolicy, timeoutInterval: serviceConfig.timeout)
        }
        
        let request = URLRequest(url: requestURL, cachePolicy: serviceConfig.cachePolicy, timeoutInterval: serviceConfig.timeout)
        
        return request
    }
    
    func constructURLQueryItems() -> [URLQueryItem] {
        let apiKey = FSAPICredentials.apiKey
        let apiSecret = FSAPICredentials.apiSecret
        
        let version = getCurrentVersion()
        
        let clientIDItem = URLQueryItem(name: QueryItems.clientID.rawValue, value: apiKey)
        let clientSecretItem = URLQueryItem(name: QueryItems.clientSecret.rawValue, value: apiSecret)
        let versionItem = URLQueryItem(name: QueryItems.v.rawValue, value: version)
        
        let items = [clientIDItem,
                     clientSecretItem,
                     versionItem]
        
        return items
    }
}
