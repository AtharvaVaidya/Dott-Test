//
//  APICredentials.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

protocol Credentials {
    static var apiKey: String { get }
    static var apiSecret: String { get }
}

// We are storing the API credentials in plain-text. For more info on why I have done this please read this article. https://nshipster.com/secrets/
/// API Client Credentials for Foursquare
struct FSAPICredentials: Credentials {
    static let apiKey = "5PUVNO5GQM2FTHS5PSZX3KM4JMNSLLTN3IRTHYQA0VTKUHOW"
    static let apiSecret = "Z142HYBS5PMAP00DEG4JKYEKJEESJSQYY4PR2STBRBVQO3FT"
}
