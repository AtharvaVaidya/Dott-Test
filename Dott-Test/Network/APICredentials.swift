//
//  APICredentials.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

protocol Credentials {
    var apiKey: String { get set }
    var apiSecret: String { get set }
}

// We are storing the APICredentials in plain-text. For more info on why I have done this please read this article. https://nshipster.com/secrets/
struct APICredentials: Credentials {
    enum CredentialType: String {
        case key = "APIKey"
        case secret = "APISecret"
    }
    
    @UserDefaultsWrapper(key: CredentialType.key.rawValue, defaultValue: "")
    var apiKey: String
    
    @UserDefaultsWrapper(key: CredentialType.secret.rawValue, defaultValue: "")
    var apiSecret: String
}
