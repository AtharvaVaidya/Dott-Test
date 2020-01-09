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
    
    private var selectedMarker: MKAnnotationView?
    
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
        viewModel.downloadRestaurantsForCurrentLocation()

        viewModel.subscribeToModel()
        .receive(on: RunLoop.main)
        .sink { [weak self] (venues) in
            self?.redrawMap()
        }
        .store(in: &cancellables)
        
        setupMap()
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.register(RestaurantAnnotation.self, forAnnotationViewWithReuseIdentifier: RestaurantAnnotation.identifier)
        mapView.camera.centerCoordinateDistance = 10000
        updateMap(currentLocation: viewModel.currentLocation)
    }
    
    func redrawMap() {
        mapView.removeAnnotations(mapView.annotations)
        
        let venues = viewModel.allRestaurants()
        let annotations = venues.map({ RestaurantAnnotation(restaurant: $0) })
                
        mapView.addAnnotations(annotations)
    }
    
    func updateMap(currentLocation: CLLocation?) {
        if let coordinates = currentLocation?.coordinate {
            mapView.setCenter(coordinates, animated: true)
        }
    }
    
    @IBAction func downloadRestaurants(_ sender: Any) {
        viewModel.downloadRestaurantsFor(view: mapView)
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
            
            let disclosureButton = UIButton(type: .detailDisclosure)
            disclosureButton.addTarget(self, action: #selector(disclosureButtonPressed), for: .touchUpInside)
            view.detailCalloutAccessoryView = disclosureButton
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedMarker = view
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedMarker = nil
    }
    
    @objc func disclosureButtonPressed() {
        guard let selectedMarker = self.selectedMarker,
            let annotation = selectedMarker.annotation as? RestaurantAnnotation else {
                return
        }
        
        let restaurant = annotation.restaurant
        
        let detailVC = RestaurantDetailVC.makeWith(restaurant: restaurant)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}



