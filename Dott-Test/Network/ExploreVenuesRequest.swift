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
    
    static let endPoint: APIEndPoint = APIEndPoints.Venues.explore
    static let authenticationType: FSRequestAuthenticationType = .userless
    
    let serviceConfig: APIServiceConfig
    
    private let latitude: Float
    private let longitude: Float
    
    private enum QueryItems: String {
        case ll = "ll"
        case clientID = "client_id"
        case clientSecret = "client_secret"
    }
    
    init(serviceConfig: APIServiceConfig, latitude: Float, longitude: Float) {
        self.serviceConfig = serviceConfig
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func constructURLQueryItems() -> [URLQueryItem] {
        let coordinates = "\(latitude), \(longitude)"
        
        let apiKey = FSAPICredentials.apiKey
        let apiSecret = FSAPICredentials.apiSecret
        
        let coordinatesItem = URLQueryItem(name: QueryItems.ll.rawValue, value: coordinates)
        let clientIDItem = URLQueryItem(name: QueryItems.clientID.rawValue, value: apiKey)
        let clientSecretItem = URLQueryItem(name: QueryItems.clientSecret.rawValue, value: apiSecret)
        
        return [coordinatesItem, clientIDItem, clientSecretItem]
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
        let endPointString = ExploreVenuesRequest.endPoint.construct()
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
}
