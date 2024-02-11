//
//  LoginViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
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
        
        startup()
    }
    
    private func startup() {
        // Form
        emailTextField.delegate = self
        pswTextField.delegate = self
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        let _ = validateForm()
        
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emailStackView)
        stackView.addArrangedSubview(pswStackView)
        stackView.addArrangedSubview(submitButton)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        pswLabel.translatesAutoresizingMaskIntoConstraints = false
        pswTextField.translatesAutoresizingMaskIntoConstraints = false
        pswStackView.translatesAutoresizingMaskIntoConstraints = false
        pswStackView.addArrangedSubview(pswLabel)
        pswStackView.addArrangedSubview(pswTextField)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
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
        guard
            validateForm(),
            let login = emailTextField.text,
            let psw = pswTextField.text
        else { return }
        
        apiService.loginAction(login: login, psw: psw) { [weak self] _ in
            let cafeListVC = CafeListViewController()
            self?.navigationController?.pushViewController(cafeListVC, animated: true)
        }
    }
    
    @objc
    private func dismissKeyboard() -> Bool {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    private func validateForm() -> Bool {
        guard let email = emailTextField.text, let psw = pswTextField.text else {
            submitButton.isEnabled = false
            return false
        }
        
        if email.isEmpty || psw.isEmpty {
            submitButton.isEnabled = false
            return false
        }
        
        submitButton.isEnabled = true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = validateForm()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
    }
}
