//
//  ViewFactory.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import UIKit

enum ScreenIdentifier {
    case authScreen
    case profileScreen
}


protocol ViewFactory {
    func makeView(for screenIdentifier: ScreenIdentifier) -> UIViewController?
}

class ViewFactoryImpl: ViewFactory {
    
    func makeView(for screenIdentifier: ScreenIdentifier) -> UIViewController? {
        switch screenIdentifier {
        case .authScreen: return makeAuthScreen()
        case .profileScreen: return makeProfileScreen()
        }
    }
}

// MARK: - Supporting functions
extension ViewFactoryImpl {
    func makeAuthScreen() -> UIViewController {
        let authVC = AuthorizationViewControllerImpl()
        let presenter = AuthorizationPresenterImpl(
            authService: AuthServiceImpl.shared,
            view: authVC)
        authVC.presenter = presenter
        return authVC
    }
    
    func makeProfileScreen() -> UIViewController? {
       
        return UIViewController()
    }
}
