//
//  LoginPresenter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol LoginPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onValidateForm(email: String?, psw: String?) -> Bool
    func onSubmitAction(login: String?, psw: String?)
    func onAuthComplete(response: AuthResponse)
}

class LoginPresenter {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
}

extension LoginPresenter: LoginPresenterProtocol {
    func onViewDidLoad() {
        view?.startup()
    }
    
    func onValidateForm(email: String?, psw: String?) -> Bool {
        return interactor?.validateForm(email: email, psw: psw) ?? false
    }
    
    func onSubmitAction(login: String?, psw: String?) {
        interactor?.auth(login: login, psw: psw)
    }
    
    func onAuthComplete(response: AuthResponse) {
        guard !response.token.isEmpty else { return }

        router?.onShowCafeListScreen()
    }
}
