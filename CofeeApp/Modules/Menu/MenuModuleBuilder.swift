//
//  MenuModuleBuilder.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import UIKit

class MenuModuleBuilder {
    static func build() -> MenuViewController {
        let view = MenuViewController()
        
        let presenter = MenuPresenter()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = MenuInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        let router = MenuRouter()
        router.view = view
        presenter.router = router
        
        return view
    }
}
