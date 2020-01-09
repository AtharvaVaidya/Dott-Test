//
//  TextHeaderView.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class TextHeaderView: UITableViewHeaderFooterView {
    let titleLabel: UILabel = UILabel()
    
    static let identifier: String = "TextHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
        makeConstraints()
        configureViews()
    }
    
    private func configureViews() {
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = .preferredFont(forTextStyle: .headline)
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutGuide = contentView.safeAreaLayoutGuide
        
        let constraints = [titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8),
                           titleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -8),
                           titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 8),
                           titleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -8)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
