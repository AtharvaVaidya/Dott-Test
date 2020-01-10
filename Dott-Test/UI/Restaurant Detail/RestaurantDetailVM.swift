//
//  RestaurantDetailVM.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import MapKit
import Combine

class RestaurantDetailVM {
    typealias VenueDetails = GetVenueResponse.VenueDetails
    
    private let model: RestaurantDetailModel
    private let apiClient = FSAPIClient()
    private let headers: [String] = ["Address", "Categories"]
    
    ///Headers for the details of a restaurant/venue.
    private let detailHeaders: [String] = ["Contact Information", "Hours", "Rating"]
    
    private var cancellables: Set<AnyCancellable> = []

    init(model: RestaurantDetailModel) {
        self.model = model
    }
    
    //MARK:- View Helper Functions
    var centrePointForMap: CLLocationCoordinate2D {
        return model.venue.location.coordinates
    }
    
    var annotation: RestaurantAnnotation {
        return RestaurantAnnotation(restaurant: model.venue)
    }
    
    var title: String {
        return model.venue.name
    }
    
    var numberOfSections: Int {
        guard let _ = model.details else {
            return headers.count
        }
        
        return headers.count + detailHeaders.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func header(for section: Int) -> String {
        if headers.indices.contains(section) {
            return headers[section]
        }
        
        let index = section - headers.count
        
        guard detailHeaders.indices.contains(index) else {
            return ""
        }
        
        return detailHeaders[index]
    }
    
    func valueForCell(at indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return formattedAddress()
        case 1:
            return formattedCategories()
        default:
            break
        }
        
        guard let _ = model.details else {
            return ""
        }
        
        switch indexPath.section {
        case 2:
            return formattedContactInfo()
        case 3:
            return formattedHours()
        case 4:
            return formattedRating()
        default:
            return ""
        }
    }
    
    //MARK:- Data Formatting Methods
    func formattedAddress() -> String {
        let restaurant = model.venue
        
        if let formattedAddress = restaurant.location.formattedAddress {
            return formattedAddress.joined(separator: "\n")
        }
        
        return restaurant.location.address ?? ""
    }
    
    func formattedCategories() -> String {
        let restaurant = model.venue
        
        return
            restaurant
            .categories
                .map({ $0.name })
                .joined(separator: ", ")
    }
    
    func formattedContactInfo() -> String {
        return model.details?.contact.formattedPhone ?? "—"
    }
    
    func formattedRating() -> String {
        guard let rating = model.details?.rating else {
            return "—"
        }
        
        return "\(rating) out of 10"
    }
    
    func formattedHours() -> String {
        guard let timeframes = model.details?.hours?.timeframes else {
            return ""
        }
        
        let daysOpen
            = timeframes
                .compactMap({ $0.days })
                .joined(separator: ", ")
        
        let hours
            = timeframes
                .compactMap({
                    $0.timeframeOpen?
                        .compactMap({ $0.renderedTime })
                        .joined(separator: ", ")
                })
                .joined(separator: "\n")
        
        if daysOpen.isEmpty && hours.isEmpty {
            return "—"
        }
        
        if hours.isEmpty {
            return "\(daysOpen)"
        } else {
            return "\(daysOpen)\n\(hours)"
        }
    }
    
    //MARK:- Binding Methods
    func bindToModel() -> AnyPublisher<Void, Never> {
        return
            model.$details
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    //MARK:- Network Functions
    func downloadDetails() {
        let request = GetVenueRequest(serviceConfig: .defaultConfig, eventID: model.venue.id)
        
        let backgroundQueue = DispatchQueue.global(qos: .background)
        
        apiClient.send(request: request)
        .receive(on: backgroundQueue)
        .sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .finished:
                print("Finished downloading details")
            }
        }) { [weak model] (response) in
            model?.details = response.response?.venue
        }
        .store(in: &cancellables)
    }
}
