//
//  CafeListRouter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol CafeListRouterProtocol: AnyObject {
    func onShowMenuScreen(cafeId: Int)
    func onShowMapScreen(items: [Cafe])
}

class CafeListRouter {
    weak var view: CafeListViewController?
}

extension CafeListRouter: CafeListRouterProtocol {
    func onShowMenuScreen(cafeId: Int) {
        let menuVC = MenuModuleBuilder.build()
        menuVC.cafeId = cafeId
        
        view?.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func onShowMapScreen(items: [Cafe]) {
        guard !items.isEmpty else { return }

        let mapVC = MapModuleBuilder.build()
        mapVC.cafeItems = items

        view?.navigationController?.pushViewController(mapVC, animated: true)
    }
}
