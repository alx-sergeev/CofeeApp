//
//  MenuInteractor.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol MenuInteractorProtocol: AnyObject {
    func onFetchMenu(with id: Int, completion: @escaping ([Product]) -> ())
}

class MenuInteractor {
    weak var presenter: MenuPresenterProtocol?
    
    private let apiService = ApiService.shared
}

extension MenuInteractor: MenuInteractorProtocol {
    func onFetchMenu(with id: Int, completion: @escaping ([Product]) -> ()) {
        apiService.getMenuByID(id) { products in
            completion(products)
        }
    }
}
