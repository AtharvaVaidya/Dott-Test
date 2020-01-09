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
        
        tableView.register(TextHeaderView.self, forHeaderFooterViewReuseIdentifier: TextHeaderView.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        setupColors()
    }
    
    func setupColors() {
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
