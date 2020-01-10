//
//  NetworkError.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

/// Possible networking errors
enum NetworkError: Error {
    case badResponse
    case error(String)
    case badStatusCode
    case failedToParseJSONData
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .badResponse:
            return "Bad Response"
        case .badStatusCode:
            return "Bad Status Code"
        case .failedToParseJSONData:
            return "Failed to parse JSON"
        case .error(let error):
            return error
        }
    }
}
