//
//  APIEndPoint.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

protocol APIEndPoint {
    static var base: String { get }
    
    func construct() -> String
}

struct APIEndPoints {
    enum Venues: APIEndPoint {
        static let base = "/venues"
        
        case explore
        case details(eventID: String)
        
        func construct() -> String {
            var result = Venues.base
            
            switch self {
            case .explore:
                result += "/explore"
            case .details(let eventID):
                result += "/\(eventID)"
            }
            
            return result
        }
    }
}
