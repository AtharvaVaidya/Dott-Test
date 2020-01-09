//
//  APIEndPoint.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

struct EndPoint {
    struct Venues {
        static let base = "/venues"
        static let explore = base + "/explore"
        
        static func details(for eventID: String) -> String {
            return base + "/\(eventID)"
        }
    }
}
