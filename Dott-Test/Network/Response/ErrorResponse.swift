//
//  ErrorResponse.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let meta: Meta
    
    // MARK: - Meta
    struct Meta: Codable {
        let code: Int
        let errorType, errorDetail: String
        let requestID: String?

        enum CodingKeys: String, CodingKey {
            case code, errorType, errorDetail
            case requestID
        }
    }
}
