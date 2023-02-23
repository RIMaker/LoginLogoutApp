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
    
    private lazy var loginTextField: AuthTextField = {
        let textField = AuthTextField(textFieldType: .defaultType)
        textField.placeholder = "Логин"
        return textField
    }()
    
    private lazy var passwordTextField: AuthTextField = {
        let textField = AuthTextField(textFieldType: .secureType)
        textField.placeholder = "Пароль"
        return textField
    }()
    
    private lazy var captchaImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "photo")
        imgView.tintColor = .gray
        return imgView
    }()
    
    private lazy var captchaTextField: AuthTextField = {
        let textField = AuthTextField(textFieldType: .defaultType)
        textField.placeholder = "Капча"
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Войти", for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var authorizationElementsStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            loginTextField,
            passwordTextField,
            captchaImageView,
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
            
            captchaImageView.heightAnchor.constraint(equalToConstant: 80),
            captchaImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func changeCaptchaImage(with url: URL) {
        self.captchaImageView.load(url: url)
    }

}
