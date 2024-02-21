//
//  LoginViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit
import SnapKit

protocol LoginViewProtocol: AnyObject {
    func startup()
}

class LoginViewController: BaseViewController {
    var presenter: LoginPresenterProtocol?
    
    private let apiService = ApiService.shared
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        
        return stackView
    }()
    
    
    // Email
    private let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "e-mail"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .textDefaultColor
        
        return label
    }()
    
    private let emailTextField = TextFieldWithPadding()
    
    // PSW
    private let pswStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let pswLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .textDefaultColor
        
        return label
    }()
    
    private let pswTextField = TextFieldWithPadding(isSecure: true)
    
    private let submitButton: UIButton = .createButton(title: "Войти")
    private let textFieldHeight = 47
    private let submitButtonHeight = 48
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Вход"
        
        presenter?.onViewDidLoad()
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    func startup() {
        // Form
        emailTextField.delegate = self
        pswTextField.delegate = self
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.isEnabled = false
        
        // Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Setup actions
extension LoginViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(emailStackView)
        stackView.addArrangedSubview(pswStackView)
        stackView.addArrangedSubview(submitButton)
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        pswStackView.addArrangedSubview(pswLabel)
        pswStackView.addArrangedSubview(pswTextField)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(150)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }
        
        pswTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }

        submitButton.snp.makeConstraints { make in
            make.height.equalTo(submitButtonHeight)
        }
    }
}

// MARK: - Additional actions
extension LoginViewController {
    @objc
    private func submitButtonPressed() {
        guard let validForm = presenter?.onValidateForm(email: emailTextField.text, psw: pswTextField.text) else {
            return
        }
        
        if validForm {
            presenter?.onSubmitAction(login: emailTextField.text, psw: pswTextField.text)
        }
    }
    
    @objc
    private func dismissKeyboard() -> Bool {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let validForm = presenter?.onValidateForm(email: emailTextField.text, psw: pswTextField.text) ?? false
        submitButton.isEnabled = validForm
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
    }
}
