//
//  MapPresenter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol MapPresenterProtocol: AnyObject {
}

class MapPresenter {
    weak var view: MapViewProtocol?
    var interactor: MapInteractorProtocol?
    var router: MapRouterProtocol?
}

extension MapPresenter: MapPresenterProtocol {
}
