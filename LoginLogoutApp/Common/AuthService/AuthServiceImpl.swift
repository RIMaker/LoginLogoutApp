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
    func getCaptcha(completion: @escaping (CaptchaResponseModel?)->())
    func signIn(login: String, password: String, captcha: CaptchaRequestData, completion: @escaping (AuthResponseModel?)->())
    func signOut()
}

class AuthServiceImpl: AuthService {
    
    static let shared = AuthServiceImpl()
    
    var state: AuthState
    
    var apiProvider: APIProvider
    
    private init() {
        state = .notAuthorized
        apiProvider = APIProviderImpl()
    }
    
    func getCaptcha(completion: @escaping (CaptchaResponseModel?)->()) {
        apiProvider.fetchData(
            CaptchaResponseModel.self,
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
    
    func signIn(login: String, password: String, captcha: CaptchaRequestData, completion: @escaping (AuthResponseModel?)->()) {
        let authRequestModel = AuthRequestModel(
            username: login,
            password: password,
            captcha: captcha)
        let httpBody = try? JSONEncoder().encode(authRequestModel)
        apiProvider.fetchData(
            AuthResponseModel.self,
            requestType: .auth,
            httpHeaders: nil,
            httpBody: httpBody
        ) { result in
            switch result {
            case .success(let authResponseModel):
                completion(authResponseModel)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func signOut() {
        
    }
    
    
}
