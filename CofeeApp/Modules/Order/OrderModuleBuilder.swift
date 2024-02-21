//
//  OrderModuleBuilder.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import UIKit

class OrderModuleBuilder {
    static func build() -> OrderViewController {
        let view = OrderViewController()
        
        let presenter = OrderPresenter()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = OrderInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        let router = OrderRouter()
        router.view = view
        presenter.router = router
        
        return view
    }
}
