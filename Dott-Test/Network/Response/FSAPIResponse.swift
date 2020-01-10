//
//  FSAPIResponse.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

public protocol FSAPIResponse: Codable {
    associatedtype ResponseData: Codable
    
    var meta: FSAPIResponseMetadata { get }
    var response: ResponseData { get }
}
