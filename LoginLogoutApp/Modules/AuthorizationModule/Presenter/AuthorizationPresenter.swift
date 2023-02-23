//
//  AuthorizationPresenter.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import Foundation

protocol AuthorizationPresenter {
    init(authService: AuthService, view: AuthorizationViewController?)
    func viewShown()
    func tapOnTheSignIn()
}

class AuthorizationPresenterImpl: AuthorizationPresenter {
    
    private var authService: AuthService
    private weak var view: AuthorizationViewController?
    
    private var captcha: Captcha?
    
    required init(authService: AuthService, view: AuthorizationViewController?) {
        self.authService = authService
        self.view = view
    }
    
    func viewShown() {
        view?.setup()
        authService.getCaptcha() { [weak self] captcha in
            self?.captcha = captcha
            if let imageData = captcha?.data.imageData, let url = URL(string: imageData) {
                self?.view?.changeCaptchaImage(with: url)
            }
        }
    }
    
    func tapOnTheSignIn() {
        
    }
    
    
}
