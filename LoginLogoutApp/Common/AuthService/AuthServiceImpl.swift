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
    var state: AuthState { get }
    func getCaptcha(completion: @escaping (CaptchaResponseModel?)->())
    func signIn(login: String, password: String, captcha: CaptchaRequestData, completion: @escaping (Bool)->())
    func signOut()
    func getUserInfo(completion: @escaping (UserInfoModel?)->())
}

class AuthServiceImpl: AuthService {
    
    static let shared = AuthServiceImpl()
    
    var state: AuthState {
        getAuthState()
    }
    
    private var apiProvider: APIProvider
    
    private init() {
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
    
    func signIn(login: String, password: String, captcha: CaptchaRequestData, completion: @escaping (Bool)->()) {
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
        ) { [weak self] result in
            switch result {
            case .success(let authResponseModel):
                self?.saveToken(authResponse: authResponseModel)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func signOut() {
        KeychainHelper.standard.delete(
            service: DefaultsKeys.tokenKey.rawValue,
            account: APIProviderImpl.baseURL
        )
    }
    
    func getUserInfo(completion: @escaping (UserInfoModel?)->()) {
        guard let result = KeychainHelper.standard.read(
            service: DefaultsKeys.tokenKey.rawValue,
            account: APIProviderImpl.baseURL,
            type: AuthTokens.self
        ) else {
            completion(nil)
            return
        }
        let httpHeaders = [
            "accept" : "application/json",
            "authorization" : "Bearer \(result.accessToken)"
        ]
        apiProvider.fetchData(
            UserInfoModel.self,
            requestType: .getUserInfo,
            httpHeaders: httpHeaders,
            httpBody: nil
        ) { result in
            switch result {
            case .success(let userInfo):
                completion(userInfo)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    private func saveToken(authResponse: AuthResponseModel?) {
        guard let authResponse = authResponse else { return }
        // Save `auth` to keychain
        KeychainHelper.standard.save(
            authResponse.data,
            service: DefaultsKeys.tokenKey.rawValue,
            account: APIProviderImpl.baseURL
        )
        UserDefaults.standard.set(Date(), forKey: DefaultsKeys.lastTokenAccessDateKey.rawValue)
    }
    
    private func getAuthState() -> AuthState {
        let result = KeychainHelper.standard.read(
            service: DefaultsKeys.tokenKey.rawValue,
            account: APIProviderImpl.baseURL,
            type: AuthTokens.self
        )
        
        let lastTokenUpdatingDate = UserDefaults.standard.object(
            forKey: DefaultsKeys.lastTokenAccessDateKey.rawValue
        ) as? Date
        
        let nowDate = Date()
        
        if
            let lastTokenUpdatingDate = lastTokenUpdatingDate,
            let result = result,
            nowDate.timeIntervalSince(lastTokenUpdatingDate) < Double(result.expiresIn)
        {
            return .authorized
        } else {
            return .notAuthorized
        }
    }
    
    
}
