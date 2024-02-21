//
//  OrderPresenter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol OrderPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onPayButtonAction()
}

class OrderPresenter {
    weak var view: OrderViewProtocol?
    var interactor: OrderInteractorProtocol?
    var router: OrderRouterProtocol?
    
    
    private func prepareItemsForView() -> [Product] {
        guard let prepareItems = interactor?.onFetchItems() else { return [] }
        
        return prepareItems.map { entity in
            let id = Int(truncatingIfNeeded: entity.id)
            let price = Int(truncatingIfNeeded: entity.price)
            return Product(id: id, name: entity.name, imageURL: nil, price: price)
        }
    }
    
    private func setItemsForView(_ items: [Product]) {
        view?.onSetItems(items)
    }
}

extension OrderPresenter: OrderPresenterProtocol {
    func onViewDidLoad() {
        let items = prepareItemsForView()
        view?.onSetItems(items)
    }
    
    func onPayButtonAction() {
        print("Оплата заказа")
    }
}
