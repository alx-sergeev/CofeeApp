//
//  RegModuleBuilder.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 20.02.2024.
//

import UIKit

class RegModuleBuilder {
    static func build() -> RegViewController {
        let view = RegViewController()
        
        let presenter = RegPresenter()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = RegInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        let router = RegRouter()
        router.view = view
        presenter.router = router
        
        return view
    }
}

