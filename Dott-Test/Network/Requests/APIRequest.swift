//
//  APIRequest.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

public protocol APIRequest {
    associatedtype Response
        
    func signed() -> URLRequest
}

public protocol FSAPIRequest: APIRequest where Response: Codable {
    var endPoint: APIEndPoint { get }
    static var authenticationType: FSRequestAuthenticationType { get }
    var serviceConfig: APIServiceConfig { get }
    
    func requestURL(queryItems: [URLQueryItem]) -> URL?
    func getCurrentVersion() -> String
}

extension FSAPIRequest {
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
