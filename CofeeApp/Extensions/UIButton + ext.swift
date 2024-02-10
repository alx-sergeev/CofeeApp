//
//  UIButton + ext.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit

extension UIButton {
    static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.buttonTextColor, for: .normal)
        button.backgroundColor = .buttonBackgroundColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        return button
    }
}
