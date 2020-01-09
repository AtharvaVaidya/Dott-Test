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
    let mapViewHeader: MKMapView = {
        let mapView = MKMapView()
//        mapView.setCenter(<#T##coordinate: CLLocationCoordinate2D##CLLocationCoordinate2D#>, animated: <#T##Bool#>)
        return mapView
    }()
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath)
        
        cell.textLabel?.text = viewModel.valueForCell(at: indexPath)
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = .preferredFont(forTextStyle: .body)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }
}

extension RestaurantDetailVC {
    static func makeWith(restaurant: Venue) -> RestaurantDetailVC {
        let viewModel = RestaurantDetailVM(restaurant: restaurant)
        let detailVC = RestaurantDetailVC(viewModel: viewModel)
        return detailVC
    }
}
