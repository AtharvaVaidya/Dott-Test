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
    
    init(viewModel: RestaurantDetailVM) {
        self.viewModel = viewModel
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        tableView.register(ValueTableViewCell.self, forCellReuseIdentifier: ValueTableViewCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? ValueTableViewCell {
            cell.mainTextLabel.text = viewModel.titleForCell(at: indexPath)
            cell.valueTextLabel.text = viewModel.valueForCell(at: indexPath)
        }
        
        return cell
    }
}

extension RestaurantDetailVC {
    static func makeWith(restaurant: Venue) -> RestaurantDetailVC {
        let viewModel = RestaurantDetailVM(restaurant: restaurant)
        let detailVC = RestaurantDetailVC(viewModel: viewModel)
        return detailVC
    }
}
