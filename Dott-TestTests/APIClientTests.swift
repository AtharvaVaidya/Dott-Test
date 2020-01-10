//
//  APIClientTests.swift
//  Dott-TestTests
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import XCTest
import Combine
@testable import Dott_Test

class APIClientTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    
    func testExploreRestaurants() {
        let apiClient = FSAPIClient()
        
        let exploreRequest = ExploreVenuesRequest(serviceConfig: .defaultConfig,
                                                  httpMethod: .get,
                                                  body: nil,
                                                  section: .food,
                                                  radius: 1000,
                                                  latitude: 40.7128,
                                                  longitude: -74.0060)
        
        let expectation = XCTestExpectation()
        
        apiClient.send(request: exploreRequest)
        .sink(receiveCompletion: { (result) in
            switch result {
            case .finished:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }) { venues in
            XCTAssertNotNil(venues.response)
            if let allVenues = venues.allVenues {
                XCTAssert(allVenues.count > 0, "Response is empty")
            } else {
                XCTFail("Response is empty")
            }
        }
        .store(in: &cancellables)
            
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetVenueDetails() {
        let apiClient = FSAPIClient()
        
        let exploreRequest = VenueRequest(serviceConfig: .defaultConfig,
                                          eventID: "53235762498e36c1448965bf")
        
        let expectation = XCTestExpectation()
        
        apiClient.send(request: exploreRequest)
        .sink(receiveCompletion: { (result) in
            switch result {
            case .finished:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }) { response in
            XCTAssertNotNil(response.response)
        }
        .store(in: &cancellables)
            
        
        wait(for: [expectation], timeout: 10)
    }
}
