//
//  FSAPIResponseMetadata.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

// MARK: - Meta
public struct FSAPIResponseMetadata: Codable {
    let code: Int
    let requestID: String?

    enum CodingKeys: String, CodingKey {
        case code
        case requestID
    }
}
