//
//  AuthorizationPresenter.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import Foundation

protocol AuthorizationPresenter {
    init(authService: AuthService, view: AuthorizationViewController?, router: RouterAuthorizationScreen)
    func viewShown()
    func getCaptcha()
    func signIn(login: String, password: String, captcha: String, completion: @escaping ()->())
}

class AuthorizationPresenterImpl: AuthorizationPresenter {
    
    private var router: RouterAuthorizationScreen
    private var authService: AuthService
    private weak var view: AuthorizationViewController?
    
    private var captchaResponseModel: CaptchaResponseModel?
    
    required init(authService: AuthService, view: AuthorizationViewController?, router: RouterAuthorizationScreen) {
        self.authService = authService
        self.view = view
        self.router = router
    }
    
    func viewShown() {
        view?.setup()
        getCaptcha()
    }
    
    func getCaptcha() {
        authService.getCaptcha() { [weak self] captchaResponse in
            self?.captchaResponseModel = captchaResponse
            if let imageData = captchaResponse?.data.imageData, let url = URL(string: imageData) {
                self?.view?.changeCaptchaImage(with: url)
            }
        }
    }
    
    func signIn(login: String, password: String, captcha: String, completion: @escaping ()->()) {
        guard let captchaKey = captchaResponseModel?.data.key else { return }
        let captchaRequestModel = CaptchaRequestData(key: captchaKey, value: captcha)
        authService.signIn(
            login: login,
            password: password,
            captcha: captchaRequestModel
        ) { [weak self] isSuccessed in
            
            guard isSuccessed else { return }

            self?.router.showProfileScreen()
        }
    }
    
    
}
