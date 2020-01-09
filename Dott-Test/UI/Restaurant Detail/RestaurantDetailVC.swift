//
//  RestaurantDetailVC.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailVC: UITableViewController {
    private let mapViewHeader: MKMapView = MKMapView()
    
    private let viewModel: RestaurantDetailVM
    
    private let cellIdentifier: String = "RestaurantDetailCell"
    
    init(viewModel: RestaurantDetailVM) {
        self.viewModel = viewModel
        
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        mapViewHeader.frame.size.height = 200

        mapViewHeader.setCenter(viewModel.centrePointForMap, animated: false)
        mapViewHeader.addAnnotation(viewModel.annotation)
        mapViewHeader.delegate = self
        mapViewHeader.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: RestaurantAnnotation.identifier)
        
        tableView.tableHeaderView = mapViewHeader
        tableView.register(TextHeaderView.self, forHeaderFooterViewReuseIdentifier: TextHeaderView.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        setupColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapViewHeader.camera.centerCoordinateDistance = 1000
    }
    
    func setupColors() {
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = viewModel.valueForCell(at: indexPath)
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = .preferredFont(forTextStyle: .body)
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .tertiarySystemGroupedBackground
        cell.backgroundColor = .tertiarySystemGroupedBackground
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TextHeaderView.identifier)
        
        if let textHeader = view as? TextHeaderView {
            textHeader.titleLabel.text = viewModel.header(for: section)
        }
        
        return view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupColors()
    }
}

extension RestaurantDetailVC {
    static func makeWith(restaurant: Venue) -> RestaurantDetailVC {
        let viewModel = RestaurantDetailVM(restaurant: restaurant)
        let detailVC = RestaurantDetailVC(viewModel: viewModel)
        return detailVC
    }
}

extension RestaurantDetailVC: MKMapViewDelegate {
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
            view.canShowCallout = false
        }
        return view
    }
}
