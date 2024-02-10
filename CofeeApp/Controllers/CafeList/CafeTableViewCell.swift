//
//  CafeTableViewCell.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit

class CafeTableViewCell: UITableViewCell {
    func configure(item: Cafe) {
        var configuration = defaultContentConfiguration()
        configuration.text = item.name
        configuration.textProperties.color = .textDefaultColor
        configuration.textProperties.font = .systemFont(ofSize: 18, weight: .bold)
        configuration.secondaryText = "1 км от вас"
        configuration.secondaryTextProperties.color = .textSecondColor
        configuration.secondaryTextProperties.font = .systemFont(ofSize: 14)
        contentConfiguration = configuration
        
        backgroundColor = .tableCellBackgroundColor
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.25
    }
}
