//
//  CafeListModuleBuilder.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import UIKit

final class CafeListModuleBuilder {
    static func build() -> CafeListViewController {
        let view = CafeListViewController()
        
        let presenter = CafeListPresenter()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = CafeListInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        let router = CafeListRouter()
        router.view = view
        presenter.router = router
        
        return view
    }
}
