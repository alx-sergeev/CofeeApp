//
//  RegRouter.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 20.02.2024.
//

import Foundation

protocol RegRouterProtocol: AnyObject {
    func onShowLoginScreen()
}

class RegRouter {
    weak var view: RegViewController?
}

extension RegRouter: RegRouterProtocol {
    func onShowLoginScreen() {
        let loginVC = LoginModuleBuilder.build()
        view?.navigationController?.pushViewController(loginVC, animated: true)
    }
}
