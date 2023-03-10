//
//  ViewController.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import UIKit

protocol AuthorizationViewController: AnyObject {
    func setup()
    func changeCaptchaImage(with data: URL)
}

class AuthorizationViewControllerImpl: UIViewController, AuthorizationViewController {
    
    var presenter: AuthorizationPresenter?
    
    private lazy var loginTextField: LLAuthTextField = {
        let textField = LLAuthTextField(textFieldType: .defaultType)
        textField.placeholder = Constants.loginPlaceholder.rawValue
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: LLAuthTextField = {
        let textField = LLAuthTextField(textFieldType: .secureType)
        textField.placeholder = Constants.passwordPlaceholder.rawValue
        textField.delegate = self
        return textField
    }()
    
    private lazy var captchaImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: SystemSymbol.placeholder.rawValue)
        imgView.tintColor = .gray
        return imgView
    }()
    
    private lazy var reloadCaptchaImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: SystemSymbol.reload.rawValue)
        imgView.tintColor = .gray
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnReloadCaptchaButton))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    private lazy var hStackForCaptcha: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [
            captchaImageView,
            reloadCaptchaImageView
        ])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 10
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.axis = .horizontal
        hStack.backgroundColor = .systemBackground
        return hStack
    }()
    
    private lazy var captchaTextField: LLAuthTextField = {
        let textField = LLAuthTextField(textFieldType: .defaultType)
        textField.placeholder = Constants.captchaPlaceholder.rawValue
        textField.delegate = self
        return textField
    }()
    
    private lazy var signInButton: LLButton = {
        let btn = LLButton()
        btn.setTitle(Constants.signInButtonTitle.rawValue, for: .normal)
        btn.addTarget(self, action: #selector(tappedOnSignInButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var authorizationElementsStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            loginTextField,
            passwordTextField,
            hStackForCaptcha,
            captchaTextField,
            signInButton
        ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 20
        vStack.distribution = .equalSpacing
        vStack.alignment = .center
        vStack.axis = .vertical
        vStack.backgroundColor = .systemBackground
        return vStack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewShown()
    }
    
    func setup() {
        view.addSubview(authorizationElementsStackView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            authorizationElementsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            authorizationElementsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authorizationElementsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authorizationElementsStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            loginTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            captchaTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            hStackForCaptcha.heightAnchor.constraint(equalToConstant: 80),
            hStackForCaptcha.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            reloadCaptchaImageView.heightAnchor.constraint(equalTo: hStackForCaptcha.heightAnchor),
            reloadCaptchaImageView.widthAnchor.constraint(equalToConstant: 40),
            
            captchaImageView.heightAnchor.constraint(equalTo: hStackForCaptcha.heightAnchor),
            
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func changeCaptchaImage(with url: URL) {
        self.captchaImageView.load(url: url)
    }
    
    @objc
    private func tappedOnSignInButton(_ sender: UIButton) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text,
            let captcha = captchaTextField.text
        else { return }
        
        presenter?.signIn(
            login: login,
            password: password,
            captcha: captcha
        )
    }
    
    @objc
    private func tappedOnReloadCaptchaButton(_ sender: UITapGestureRecognizer) {
        presenter?.getCaptcha()
    }

}


// MARK: UITextFieldDelegate
extension AuthorizationViewControllerImpl: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
