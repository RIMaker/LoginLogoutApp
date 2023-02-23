//
//  ProfilePresenter.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

protocol ProfilePresenter {
    init(authService: AuthService, view: ProfileViewController?, router: RouterProfileScreen)
    func viewShown()
    func signOut() 
}

class ProfilePresenterImpl: ProfilePresenter {
    
    private var authService: AuthService
    private var router: RouterProfileScreen
    private weak var view: ProfileViewController?
    
    required init(authService: AuthService, view: ProfileViewController?, router: RouterProfileScreen) {
        self.authService = authService
        self.view = view
        self.router = router
    }
    
    func viewShown() {
        view?.setup()
    }
    
    func signOut() {
        router.showAuthorizationScreen()
    }
    
    
}
