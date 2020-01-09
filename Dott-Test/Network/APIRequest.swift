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
    static var endPoint: APIEndPoint { get }
    static var authenticationType: FSRequestAuthenticationType { get }
    var serviceConfig: APIServiceConfig { get }
    
    func requestURL(queryItems: [URLQueryItem]) -> URL?
}
