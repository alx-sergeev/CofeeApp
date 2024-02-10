//
//  RegViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import UIKit
import SnapKit

class RegViewController: BaseViewController {
    
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
    
    // Psw repeat
    private let pswRepeatStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let pswRepeatLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите пароль"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .textDefaultColor
        
        return label
    }()
    
    private let pswRepeatTextField = TextFieldWithPadding(isSecure: true)
    
    private let submitButton: UIButton = .createButton(title: "Регистрация")
    private let textFieldHeight = 47
    private let submitButtonHeight = 48
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Регистрация"
        
        startup()
    }

    
    private func startup() {
        // Form
        emailTextField.delegate = self
        pswTextField.delegate = self
        pswRepeatTextField.delegate = self
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        let _ = validateForm()
        
        // Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Setup actions
extension RegViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emailStackView)
        stackView.addArrangedSubview(pswStackView)
        stackView.addArrangedSubview(pswRepeatStackView)
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
        
        pswRepeatLabel.translatesAutoresizingMaskIntoConstraints = false
        pswRepeatTextField.translatesAutoresizingMaskIntoConstraints = false
        pswRepeatStackView.translatesAutoresizingMaskIntoConstraints = false
        pswRepeatStackView.addArrangedSubview(pswRepeatLabel)
        pswRepeatStackView.addArrangedSubview(pswRepeatTextField)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(150)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }
        
        pswTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }
        
        pswRepeatTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }
        
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(submitButtonHeight)
        }
    }
}

// MARK: - Additional actions
extension RegViewController {
    @objc
    private func submitButtonPressed() {
        guard
            validateForm(),
            let login = emailTextField.text,
            let psw = pswTextField.text
        else { return }
        
        apiService.registrationAction(login: login, psw: psw) { [weak self] _ in
            print("Good job reg!")
            let loginVC = LoginViewController()
            self?.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @objc
    private func dismissKeyboard() -> Bool {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension RegViewController: UITextFieldDelegate {
    private func validateForm() -> Bool {
        guard let email = emailTextField.text, let psw = pswTextField.text, let repeatPsw = pswRepeatTextField.text else {
            submitButton.isEnabled = false
            return false
        }
        
        if (email.isEmpty || psw.isEmpty || repeatPsw.isEmpty) || (psw != repeatPsw) {
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
