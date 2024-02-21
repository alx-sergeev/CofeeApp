//
//  RegViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import UIKit
import SnapKit

protocol RegViewProtocol: AnyObject {
    func startup()
}

class RegViewController: BaseViewController {
    var presenter: RegPresenterProtocol?
    
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
    private let repeatPswStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let repeatPswLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите пароль"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .textDefaultColor
        
        return label
    }()
    
    private let repeatPswTextField = TextFieldWithPadding(isSecure: true)
    
    private let submitButton: UIButton = .createButton(title: "Регистрация")
    private let textFieldHeight = 47
    private let submitButtonHeight = 48
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Регистрация"
        
        presenter?.onViewDidLoad()
    }
}

// MARK: - RegViewProtocol
extension RegViewController: RegViewProtocol {
    func startup() {
        // Form
        emailTextField.delegate = self
        pswTextField.delegate = self
        repeatPswTextField.delegate = self
        
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.isEnabled = false
        
        // Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Setup actions
extension RegViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addViews(stackView)
        
        stackView.addArrangedSubview(emailStackView)
        stackView.addArrangedSubview(pswStackView)
        stackView.addArrangedSubview(repeatPswStackView)
        stackView.addArrangedSubview(submitButton)
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        pswStackView.addArrangedSubview(pswLabel)
        pswStackView.addArrangedSubview(pswTextField)
        
        repeatPswStackView.addArrangedSubview(repeatPswLabel)
        repeatPswStackView.addArrangedSubview(repeatPswTextField)
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
        
        repeatPswTextField.snp.makeConstraints { make in
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
        guard let validForm = presenter?.onValidateForm(email: emailTextField.text, psw: pswTextField.text, repeatPsw: repeatPswTextField.text) else {
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
extension RegViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let validForm = presenter?.onValidateForm(email: emailTextField.text, psw: pswTextField.text, repeatPsw: repeatPswTextField.text) ?? false
        submitButton.isEnabled = validForm
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
    }
}
