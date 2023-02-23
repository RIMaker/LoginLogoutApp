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
        
        let result = KeychainHelper.standard.read(service: DefaultsKeys.tokenKey.rawValue,
                                                  account: APIProviderImpl.baseURL,
                                                  type: AuthTokens.self)
        
        let lastTokenUpdatingDate = UserDefaults.standard.object(
            forKey: DefaultsKeys.lastTokenAccessDateKey.rawValue
        ) as? Date
        
        let nowDate = Date()
        if let lastTokenUpdatingDate = lastTokenUpdatingDate, let result = result {
            if nowDate.timeIntervalSince(lastTokenUpdatingDate) >= Double(result.expiresIn) {
                window?.rootViewController = viewFactory.makeView(for: .authScreen)
            } else {
                window?.rootViewController = viewFactory.makeView(for: .profileScreen)
            }
        }
        window?.makeKeyAndVisible()
        
    }

}

