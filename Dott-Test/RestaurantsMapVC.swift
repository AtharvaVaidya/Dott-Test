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
    
    private var viewModel: RestaurantsMapVM
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var locationSubscriber = PassthroughSubject<CLLocation?, Never>()
    
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

        viewModel.subscribeToModel()
        .receive(on: RunLoop.main)
        .sink { [weak self] (venues) in
            self?.redrawMap()
        }
        .store(in: &cancellables)
        
        viewModel.subscribeToLocationChanges()
        .receive(on: RunLoop.main)
        .sink { [weak self] (location) in
            self?.updateMap(currentLocation: location)
        }
        .store(in: &cancellables)
        
        setupMap()
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.register(RestaurantAnnotation.self, forAnnotationViewWithReuseIdentifier: RestaurantAnnotation.identifier)
        mapView.camera.centerCoordinateDistance = 10000
    }
    
    func redrawMap() {
        if let currentLocation = viewModel.currentLocation {
            mapView.setCenter(currentLocation.coordinate, animated: true)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        
        let venues = viewModel.allRestaurants()
        let annotations = venues.map({ RestaurantAnnotation(restaurant: $0) })
        
        print("Got venues: \(venues)")
        
        mapView.addAnnotations(annotations)
    }
    
    func updateMap(currentLocation: CLLocation?) {
//        if let coordinates = currentLocation?.coordinate {
//            mapView.setCenter(coordinates, animated: true)
//        }
    }
}
extension RestaurantsMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? RestaurantAnnotation else {
            return nil
        }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.detailCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}



