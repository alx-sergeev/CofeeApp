//
//  CafeListPresenter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import Foundation
import CoreLocation

protocol CafeListPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onGetDistanceForCell(item: Cafe, userLocation: CLLocation?) -> String?
    func onSelectedRow(with id: Int)
    func onMapButtonAction(items: [Cafe])
}

class CafeListPresenter {
    weak var view: CafeListViewProtocol?
    var interactor: CafeListInteractorProtocol?
    var router: CafeListRouterProtocol?
}

extension CafeListPresenter: CafeListPresenterProtocol {
    func onViewDidLoad() {
        view?.onStartLocation()
        interactor?.onFetchLocations { [weak self] items in
            self?.view?.onSetItems(items)
        }
    }
    
    func onGetDistanceForCell(item: Cafe, userLocation: CLLocation?) -> String? {
        guard let userLocation = userLocation else { return nil }
        return interactor?.onGetDistance(item: item, userLocation: userLocation)
    }
    
    func onSelectedRow(with id: Int) {
        router?.onShowMenuScreen(cafeId: id)
    }
    
    func onMapButtonAction(items: [Cafe]) {
        guard !items.isEmpty else { return }
        router?.onShowMapScreen(items: items)
    }
}
