//
//  AuthService.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import Foundation

enum AuthState {
    case authorized
    case notAuthorized
}

protocol AuthService {
    var state: AuthState { get set }
    func getCaptcha(completion: @escaping (Captcha?)->())
    func login()
    func logout()
}

class AuthServiceImpl: AuthService {
    
    static let shared = AuthServiceImpl()
    
    var state: AuthState
    
    var apiProvider: APIProvider
    
    private init() {
        state = .notAuthorized
        apiProvider = APIProviderImpl()
    }
    
    func getCaptcha(completion: @escaping (Captcha?)->()) {
        apiProvider.fetchData(
            Captcha.self,
            requestType: .getCaptcha,
            httpHeaders: nil,
            httpBody: nil
        ) { result in
            switch result {
            case .success(let captcha):
                completion(captcha)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        
        }
    }
    
    func login() {
        
    }
    
    func logout() {
        
    }
    
    
}
