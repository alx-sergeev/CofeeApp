//
//  TextFieldWithPadding.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import UIKit

class TextFieldWithPadding: UITextField {
    
    init(isSecure: Bool = false) {
        super.init(frame: CGRect())
        
        self.isSecureTextEntry = isSecure
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.textDefaultColor.cgColor
        self.layer.cornerRadius = 20
        self.textColor = .textDefaultColor
        self.font = .systemFont(ofSize: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
