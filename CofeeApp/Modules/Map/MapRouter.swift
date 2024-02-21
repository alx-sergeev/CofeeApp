//
//  MapRouter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol MapRouterProtocol: AnyObject {
}

class MapRouter {
    weak var view: MapViewController?
}

extension MapRouter: MapRouterProtocol {
}
