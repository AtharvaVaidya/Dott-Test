//
//  ValueTableViewCell.swift
//  Dott-Test
//
//  Created by Atharva Vaidya on 1/10/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class ValueTableViewCell: UITableViewCell {
    let mainTextLabel: UILabel = UILabel()
    let valueTextLabel: UILabel = UILabel()

    static let identifier: String = "ValueTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        makeConstraints()
        setupColors()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addSubviews()
        makeConstraints()
        setupColors()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            mainTextLabel.textColor = .white
            valueTextLabel.textColor = .secondaryLabel
            backgroundColor = .globalCellHighlightColor
            contentView.backgroundColor = .globalCellHighlightColor
        } else {
            setupColors()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            mainTextLabel.textColor = .white
            valueTextLabel.textColor = .secondaryLabel
            backgroundColor = .globalCellHighlightColor
            contentView.backgroundColor = .globalCellHighlightColor
        } else {
            setupColors()
        }
    }

    private func addSubviews() {
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(valueTextLabel)

        mainTextLabel.textColor = .label
        valueTextLabel.textColor = .secondaryLabel

        mainTextLabel.textAlignment = .left
        valueTextLabel.textAlignment = .right
        
//        mainTextLabel.font = .fontFor(textType: .label)
    }

    private func makeConstraints() {
        let views = [valueTextLabel, mainTextLabel]
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints = [valueTextLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
                           valueTextLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
                           valueTextLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2),
                           mainTextLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
                           mainTextLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
                           mainTextLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2),
                           mainTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueTextLabel.leadingAnchor, constant: -8)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupColors() {
        mainTextLabel.textColor = .label
        valueTextLabel.textColor = .secondaryLabel
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        accessoryView?.backgroundColor = .secondarySystemBackground
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupColors()
    }
}
