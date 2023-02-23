//
//  SceneDelegate.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    lazy var viewFactory: ViewFactory = ViewFactoryImpl()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .white
        window?.overrideUserInterfaceStyle = .light
        window?.windowScene = windowScene
        
        switch AuthServiceImpl.shared.state {
        case .notAuthorized:
            window?.rootViewController = viewFactory.makeView(for: .authScreen)
        case .authorized:
            window?.rootViewController = viewFactory.makeView(for: .profileScreen)
        }
        
        window?.makeKeyAndVisible()
        
    }

}

