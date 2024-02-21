//
//  MenuPresenter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol MenuPresenterProtocol: AnyObject {
    func onViewDidLoad(cafeId: Int?)
    func onOrderButtonAction()
}

class MenuPresenter {
    weak var view: MenuViewProtocol?
    var interactor: MenuInteractorProtocol?
    var router: MenuRouterProtocol?
}

extension MenuPresenter: MenuPresenterProtocol {
    func onViewDidLoad(cafeId: Int?) {
        guard let cafeId = cafeId else { return }
        
        interactor?.onFetchMenu(with: cafeId) { [weak self] items in
            self?.view?.onSetItems(items)
        }
    }
    
    func onOrderButtonAction() {
        router?.onShowOrderScreen()
    }
}
