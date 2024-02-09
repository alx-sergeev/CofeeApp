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
        
        view.backgroundColor = .white
        
        configureNavBar()
    }
    
    private func configureNavBar() {
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
