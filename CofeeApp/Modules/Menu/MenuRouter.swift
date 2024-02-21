//
//  MenuRouter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol MenuRouterProtocol: AnyObject {
    func onShowOrderScreen()
}

class MenuRouter {
    weak var view: MenuViewController?
}

extension MenuRouter: MenuRouterProtocol {
    func onShowOrderScreen() {
        let orderVC = OrderModuleBuilder.build()
        view?.navigationController?.pushViewController(orderVC, animated: true)
    }
}
