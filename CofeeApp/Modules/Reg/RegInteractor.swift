//
//  RegInteractor.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 20.02.2024.
//

import Foundation

protocol RegInteractorProtocol: AnyObject {
    func validateForm(email: String?, psw: String?, repeatPsw: String?) -> Bool
    func registration(login: String?, psw: String?)
}

class RegInteractor {
    weak var presenter: RegPresenterProtocol?
    
    private let apiService = ApiService.shared
}

extension RegInteractor: RegInteractorProtocol {
    func validateForm(email: String?, psw: String?, repeatPsw: String?) -> Bool {
        guard
            let email = email,
            let psw = psw,
            let repeatPsw = repeatPsw
        else {
            return false
        }
        
        if (email.isEmpty || psw.isEmpty || repeatPsw.isEmpty) || (psw != repeatPsw) {
            return false
        }

        return true
    }
    
    func registration(login: String?, psw: String?) {
        guard let login = login, let psw = psw else {
            return
        }
        
        apiService.registrationAction(login: login, psw: psw) { [weak self] response in
            self?.presenter?.onRegisterComplete(response: response)
        }
    }
}
