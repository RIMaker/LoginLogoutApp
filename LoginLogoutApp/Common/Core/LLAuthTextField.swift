//
//  PasswordTextField.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import UIKit

enum TextFieldType {
    case secureType
    case defaultType
}

class LLAuthTextField: UITextField {
    
    private let textFieldType: TextFieldType
    
    init(textFieldType: TextFieldType) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        setup()
        if textFieldType == .secureType {
            isSecureTextEntry = true
            enablePasswordToggle()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10);
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        autocorrectionType = .no
        autocapitalizationType = .none
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }
    
    @objc
    private func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        setPasswordToggleImage(sender as! UIButton)
    }
    
    private func setPasswordToggleImage(_ button: UIButton) {
        if isSecureTextEntry {
            button.setImage(UIImage(systemName: SystemSymbol.eye.rawValue), for: .normal)
        }else{
            button.setImage(UIImage(systemName: SystemSymbol.eyeSlash.rawValue), for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder) is not implemented")
    }
}
