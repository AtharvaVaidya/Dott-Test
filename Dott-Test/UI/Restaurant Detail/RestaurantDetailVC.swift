//
//  RestaurantDetailVC.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import MapKit
import Combine

class RestaurantDetailVC: UITableViewController {
    private let mapViewHeader: MKMapView = MKMapView()
    
    private let viewModel: RestaurantDetailVM
    
    private let cellIdentifier: String = "RestaurantDetailCell"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: RestaurantDetailVM) {
        self.viewModel = viewModel
        
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        setupMapView()
        setupTableView()
        setupColors()
        
        viewModel.downloadDetails()
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapViewHeader.camera.centerCoordinateDistance = 1000
    }
    
    func setupMapView() {
        mapViewHeader.frame.size.height = 200
        
        mapViewHeader.setCenter(viewModel.centrePointForMap, animated: false)
        mapViewHeader.addAnnotation(viewModel.annotation)
        
        mapViewHeader.delegate = self
        
        //Register an annotation view
//        mapViewHeader.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: RestaurantAnnotation.identifier)
    }
    
    func setupTableView() {
        tableView.tableHeaderView = mapViewHeader
        tableView.register(TextHeaderView.self, forHeaderFooterViewReuseIdentifier: TextHeaderView.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    //MARK:- Trait Collection Methods
    func setupColors() {
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupColors()
    }
    
    //MARK:- Binding Methods
    func setupBindings() {
        viewModel.bindToModel()
        .receive(on: RunLoop.main)
        .sink { [weak tableView] in
            tableView?.reloadData()
        }
        .store(in: &cancellables)
    }
}

extension RestaurantDetailVC {
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
        cell.contentView.backgroundColor = .secondarySystemGroupedBackground
        cell.backgroundColor = .secondarySystemGroupedBackground
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TextHeaderView.identifier)
        
        if let textHeader = view as? TextHeaderView {
            textHeader.titleLabel.text = viewModel.header(for: section)
        }
        
        return view
    }
}

extension RestaurantDetailVC {
    static func makeWith(restaurant: Venue) -> RestaurantDetailVC {
        let model = RestaurantDetailModel(venue: restaurant)
        let viewModel = RestaurantDetailVM(model: model)
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
