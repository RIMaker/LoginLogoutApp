//
//  Router.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import UIKit

protocol RouterBase {
    var viewFactory: ViewFactory? { get set }
}

protocol RouterAuthorizationScreen: RouterBase {
    func showProfileScreen()
}

protocol RouterProfileScreen: RouterBase {
    func showAuthorizationScreen()
}

class RouterImpl: RouterAuthorizationScreen, RouterProfileScreen {
    
    var viewFactory: ViewFactory?
    
    init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }
    
    func showProfileScreen() {
        changeRootVC(to: .profileScreen)
    }
    
    func showAuthorizationScreen() {
        changeRootVC(to: .authScreen)
    }
    
    private func changeRootVC(to viewController: ScreenIdentifier) {
        DispatchQueue.main.async { [weak self] in
            guard
                let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first,
                let newVC = self?.viewFactory?.makeView(for: viewController)
            else { return }
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = newVC
                UIView.setAnimationsEnabled(oldState)
            })
        }
    }
}
