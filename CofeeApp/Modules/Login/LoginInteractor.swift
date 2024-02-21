//
//  LoginInteractor.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol LoginInteractorProtocol: AnyObject {
    func validateForm(email: String?, psw: String?) -> Bool
    func auth(login: String?, psw: String?)
}

class LoginInteractor {
    weak var presenter: LoginPresenterProtocol?
    
    private let apiService = ApiService.shared
}

extension LoginInteractor: LoginInteractorProtocol {
    func validateForm(email: String?, psw: String?) -> Bool {
        guard let email = email, let psw = psw else {
            return false
        }
        
        if email.isEmpty || psw.isEmpty {
            return false
        }

        return true
    }
    
    func auth(login: String?, psw: String?) {
        guard let login = login, let psw = psw else {
            return
        }
        
        apiService.loginAction(login: login, psw: psw) { [weak self] response in
            self?.presenter?.onAuthComplete(response: response)
        }
    }
}
