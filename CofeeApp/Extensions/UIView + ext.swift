//
//  UIView + ext.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import UIKit

extension UIView {
    func addViews(_ views: UIView...) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
