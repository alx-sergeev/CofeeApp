//
//  RegPresenter.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 20.02.2024.
//

import Foundation

protocol RegPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onValidateForm(email: String?, psw: String?, repeatPsw: String?) -> Bool
    func onSubmitAction(login: String?, psw: String?)
    func onRegisterComplete(response: AuthResponse)
}

class RegPresenter {
    weak var view: RegViewProtocol?
    var interactor: RegInteractorProtocol?
    var router: RegRouterProtocol?
}

extension RegPresenter: RegPresenterProtocol {
    func onViewDidLoad() {
        view?.startup()
    }
    
    func onValidateForm(email: String?, psw: String?, repeatPsw: String?) -> Bool {
        return interactor?.validateForm(email: email, psw: psw, repeatPsw: repeatPsw) ?? false
    }
    
    func onSubmitAction(login: String?, psw: String?) {
        interactor?.registration(login: login, psw: psw)
    }
    
    func onRegisterComplete(response: AuthResponse) {
        guard !response.token.isEmpty else { return }

        router?.onShowLoginScreen()
    }
}
