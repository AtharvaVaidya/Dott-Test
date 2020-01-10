//
//  APIClient.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import Combine

protocol APIClient {
    func send<T: APIRequest>(request: T) -> AnyPublisher<Data, NetworkError>
    func send<T: FSAPIRequest>(request: T) -> AnyPublisher<T.Response, NetworkError>
}

class FSAPIClient: APIClient {
    func send<T: APIRequest>(request: T) -> AnyPublisher<Data, NetworkError> {
        let urlRequest = request.signed()
        
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    print("Bad status code")
                    throw NetworkError.badResponse
                }
                
                if response.statusCode != 200 {
                    print("Status code: \(response.statusCode)")
                    throw NetworkError.badStatusCode
                }
                
                return data
            })
            .mapError({ (error) -> NetworkError in
                return NetworkError.badResponse
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func send<T: FSAPIRequest>(request: T) -> AnyPublisher<T.Response, NetworkError> {
        let urlRequest = request.signed()
        
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .retry(5)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    print("Bad status code")
                    throw NetworkError.badResponse
                }
                
                if response.statusCode != 200 {
                    print("Status code: \(response.statusCode)")
                    print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                    throw NetworkError.badStatusCode
                }
                
                return data
            }
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .tryMap({ (response) -> T.Response in
                guard response.meta.code == 200 else {
                    throw NetworkError.badStatusCode
                }
                
                return response
            })
            .mapError { (error) -> NetworkError in
                print("Error decodeing JSON: \((error as NSError).userInfo)")
                return NetworkError.failedToParseJSONData
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}
