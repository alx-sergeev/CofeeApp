//
//  OrderInteractor.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol OrderInteractorProtocol: AnyObject {
    func onFetchItems() -> [ProductOrder]
}

class OrderInteractor {
    weak var presenter: OrderPresenterProtocol?
    
    private let coreDataManager = CoreDataManager.shared
}

extension OrderInteractor: OrderInteractorProtocol {
    func onFetchItems() -> [ProductOrder] {
        return coreDataManager.fetchItems()
    }
}
