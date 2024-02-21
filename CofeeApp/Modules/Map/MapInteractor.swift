//
//  MapInteractor.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol MapInteractorProtocol: AnyObject {
}

class MapInteractor {
    weak var presenter: MapPresenterProtocol?
}

extension MapInteractor: MapInteractorProtocol {
}
