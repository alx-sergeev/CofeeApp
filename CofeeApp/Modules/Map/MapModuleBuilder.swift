//
//  MapModuleBuilder.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import UIKit

class MapModuleBuilder {
    static func build() -> MapViewController {
        let view = MapViewController()
        
        let presenter = MapPresenter()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = MapInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        let router = MapRouter()
        router.view = view
        presenter.router = router
        
        return view
    }
}
