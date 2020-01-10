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
    static let apiKey = "3542X1VTSY440WPXIZ2XSWDB2JSTZON3AZHWG0A4KDSTJYAC"
    static let apiSecret = "1GROI4NX53CDRKMOGLE5GE1K2X4BGRHLH1LQ24GSXLIANHWN"
}
