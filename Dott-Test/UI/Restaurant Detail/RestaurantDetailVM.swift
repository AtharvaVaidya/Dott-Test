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
    private let model: RestaurantDetailModel
    private let apiClient = FSAPIClient()
    private let headers: [String] = ["Address", "Categories"]
    
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
        return headers.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func header(for section: Int) -> String {
        guard headers.indices.contains(section) else {
            return ""
        }
        
        return headers[section]
    }
    
    func valueForCell(at indexPath: IndexPath) -> String {
        let restaurant = model.venue
        
        switch indexPath.section {
        case 0:
            return restaurant.location.formattedAddress?.joined(separator: "\n") ?? (restaurant.location.address ?? "")
        case 1:
            return restaurant.categories.map({ $0.name }).joined(separator: ", ")
        default:
            return ""
        }
    }
    
    //MARK:- Network Functions
    func downloadDetails() {
        let request = VenueRequest(serviceConfig: .defaultConfig, eventID: model.venue.id)
        
        let backgroundQueue = DispatchQueue.global(qos: .background)
        
        apiClient.send(request: request)
        .receive(on: backgroundQueue)
        .sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .finished:
                print("Finished downloading details")
                print("Details: \(self.model.details)")
            }
        }) { [weak model] (response) in
            model?.details = response.response.venue
        }
        .store(in: &cancellables)
    }
}
