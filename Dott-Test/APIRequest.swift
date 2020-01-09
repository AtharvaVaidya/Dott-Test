//
//  APIRequest.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    func urlRequest() -> URLRequest
}
