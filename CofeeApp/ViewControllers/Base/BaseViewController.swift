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
//        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "list.bullet")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "list.bullet")
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .navBarBackgroundColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.textDefaultColor, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        navBarAppearance.shadowColor = .navBarShadowColor

        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationBar?.isTranslucent = false
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
