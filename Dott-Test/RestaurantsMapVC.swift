//
//  ViewController.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/9/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import MapKit
import Combine

class RestaurantsMapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let viewModel: RestaurantsMapVM
    
    private var cancellables: Set<AnyCancellable> = []
    
    init?(coder: NSCoder, viewModel: RestaurantsMapVM) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = RestaurantsMapVM()
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestLocationPermissionIfNeeded()
        viewModel.downloadRestaurants()
        
        viewModel.objectWillChange
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                break
            case .finished:
                self?.redrawMap()
            }
        }, receiveValue: {})
        .store(in: &cancellables)
        
        setupMap()
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.register(RestaurantAnnotation.self, forAnnotationViewWithReuseIdentifier: RestaurantAnnotation.identifier)
    }
    
    func redrawMap() {
        if let currentLocation = viewModel.currentLocation {
            mapView.setCenter(currentLocation.coordinate, animated: true)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        
        let venues = viewModel.allRestaurants()
        let annotations = venues.map({ RestaurantAnnotation(restaurant: $0) })
        mapView.addAnnotations(annotations)
    }
}
extension RestaurantsMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: RestaurantAnnotation.identifier, for: annotation) 
        
        return view
    }
}



