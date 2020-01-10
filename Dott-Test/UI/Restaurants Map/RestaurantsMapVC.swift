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
    
    /// The distance from the ground level to the camera in metres
    private let defaultCameraDistance: CLLocationDistance = 10_000
    
    private var viewModel: RestaurantsMapVM
    
    private var cancellables: Set<AnyCancellable> = []
    private var locationPermissionsListener: AnyCancellable?
    
    private var selectedMarker: MKAnnotationView?
    
    @Published private var currentMapCentre: CLLocationCoordinate2D
    
    init?(coder: NSCoder, viewModel: RestaurantsMapVM) {
        self.viewModel = viewModel
        currentMapCentre = mapView?.centerCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = RestaurantsMapVM()
        currentMapCentre = mapView?.centerCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupBindings()
        setupMap()
        setupColors()
        showLocationPermissionAlertIfNeeded()
    }
    
    @IBAction func goToCurrentLocationPressed(_ sender: Any) {
        if viewModel.shouldShowPermissionError {
            showLocationPermissionAlertIfNeeded()
            return
        } else if viewModel.locationPermissionUndetermined {
            viewModel.requestLocationPermissionIfNeeded()
            subscribeToPermissionUpdate()
        }
        
        goToCurrentLocation()
    }
    
    func goToCurrentLocation() {
        updateMap(currentLocation: viewModel.currentLocation)
        viewModel.downloadRestaurantsForCurrentLocation()
    }
    
    private func setupBindings() {
        func subscribeToModel() {
            viewModel.subscribeToModel()
            .receive(on: RunLoop.main)
            .sink { [weak self] (venues) in
                self?.redrawMap()
            }
            .store(in: &cancellables)
        }
        func subscribeToCameraChanges() {
            let backgroundQueue = DispatchQueue.global(qos: .default)
        
            let modelUpdatePublisher
                = viewModel.subscribeToModel()
                    .map({ _ in })
                    .eraseToAnyPublisher()
            
            let locationPermissionPublisher
                = viewModel.subscribeToLocationPermissionChanges()
                    .map({ _ in })
                    .eraseToAnyPublisher()
            
            let currentMapCentrePublisher
                = $currentMapCentre
                    .map({ _ in })
                    .eraseToAnyPublisher()
            
            //We wait until one of these 3 publishes a value to start calling the API for restaurants at a certain location on a map.
            let waitUntilPublisher = Publishers.Merge3(modelUpdatePublisher, locationPermissionPublisher, currentMapCentrePublisher)
            
            $currentMapCentre
            .drop(untilOutputFrom: waitUntilPublisher)
            //We wait for the user to stay in a place for one second before firing a network request because the user might be moving the map a lot.
            .debounce(for: 1, scheduler: backgroundQueue)
            .removeDuplicates(by: ~=)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self, let mapView = self.mapView else {
                    return
                }
                
                self.viewModel.changedPositionFor(camera: mapView)
            }
            .store(in: &cancellables)
        }

        subscribeToModel()
        subscribeToCameraChanges()
    }
    
    func subscribeToPermissionUpdate() {
        self.locationPermissionsListener
            = viewModel.subscribeToLocationPermissionChanges()
                .receive(on: RunLoop.main)
                .sink { [weak self] (status) in
                    guard let self = self else {
                        return
                    }
                    
                    switch status {
                    case .authorizedAlways, .authorizedWhenInUse:
                        self.goToCurrentLocation()
                    default:
                        break
                    }
                }
    }
    
    
    func fetchData() {
        viewModel.downloadRestaurantsForCurrentLocation()
    }
    
    //MARK:- MapView Methods
    private func setupMap() {
        mapView.delegate = self
        mapView.camera.centerCoordinateDistance = defaultCameraDistance
        updateMap(currentLocation: viewModel.currentLocation)
    }
    
    private func redrawMap() {
        let newVenues = viewModel.allRestaurants()

        let annotationsToRemove
            = mapView.annotations
                .compactMap({ ($0 as? RestaurantAnnotation) })
                .filter({ !newVenues.contains($0.restaurant) })
        
        mapView.removeAnnotations(annotationsToRemove)
        
        let annotationsToAdd: Set<Venue>
            = newVenues.filter({ venue -> Bool in
                !annotationsToRemove.contains(where: { $0.restaurant == venue })
            })
        
        let annotations = annotationsToAdd.map({ RestaurantAnnotation(restaurant: $0) })
                
        mapView.addAnnotations(annotations)
    }
    
    private func updateMap(currentLocation: CLLocation?) {
        if let coordinates = currentLocation?.coordinate {
            mapView.setCenter(coordinates, animated: true)
        }
    }
    
    private func showLocationPermissionAlertIfNeeded() {
        if viewModel.shouldShowPermissionError {
            showError(title: "Error", message: "Please provide location permissions to search for restaurants")
        }
    }
    
    //MARK:- Trait Collection Methods
    private func setupColors() {
        view.backgroundColor = .secondarySystemGroupedBackground
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupColors()
    }
    
    //MARK:- Error Alert
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
extension RestaurantsMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestaurantAnnotation else {
            return nil
        }
        
        let identifier = RestaurantAnnotation.identifier
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //Only updating the current map centre value if the user moved the map.
        if !animated {
            currentMapCentre = mapView.centerCoordinate
        }
    }
    
    @objc private func disclosureButtonPressed() {
        guard let selectedMarker = self.selectedMarker,
            let annotation = selectedMarker.annotation as? RestaurantAnnotation else {
                return
        }
        
        let restaurant = annotation.restaurant
        
        let detailVC = RestaurantDetailVC.makeWith(restaurant: restaurant)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


fileprivate extension CLLocationCoordinate2D {
    /// Returns true if both the location's are close enough to a arcsecond.
    static func ~=(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        //Making sure we don't send another request for an area that is roughly the same by checking if the last location is within a "second" of the last one.
        let marginOfError = (1 / 60.0) / 60.0
        
        let latitudeDelta = fabs(lhs.latitude - rhs.latitude)
        let longitudeDelta = fabs(lhs.longitude - rhs.longitude)
        
        let isDuplicate = latitudeDelta < marginOfError && longitudeDelta < marginOfError
        
        return isDuplicate
    }
}
