//
//  BaseViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    private func configureNavBar() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .navBarBackgroundColor
        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.textDefaultColor,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        standardAppearance.shadowColor = .navBarShadowColor
        
        let backImage = UIImage(named: "back_button")
        standardAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationItem.backButtonTitle = ""
        navigationItem.standardAppearance = standardAppearance
        navigationItem.scrollEdgeAppearance = standardAppearance
    }
}

// MARK: - Setup actions
@objc
extension BaseViewController {
    func setupViews() {}
    func constraintViews() {}
    func configureAppearance() {
        view.backgroundColor = .white
    }
}
