//
//  LoginRouter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol LoginRouterProtocol: AnyObject {
    func onShowCafeListScreen()
}

class LoginRouter {
    weak var view: LoginViewController?
}

extension LoginRouter: LoginRouterProtocol {
    func onShowCafeListScreen() {
        let cafeListVC = CafeListModuleBuilder.build()
        view?.navigationController?.pushViewController(cafeListVC, animated: true)
    }
}
