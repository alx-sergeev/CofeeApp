//
//  LoginModuleBuilder.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import UIKit

class LoginModuleBuilder {
    static func build() -> LoginViewController {
        let view = LoginViewController()
        
        let presenter = LoginPresenter()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = LoginInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        let router = LoginRouter()
        router.view = view
        presenter.router = router
        
        return view
    }
}
