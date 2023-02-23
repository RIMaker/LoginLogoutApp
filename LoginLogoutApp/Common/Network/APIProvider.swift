//
//  APIProvider.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import UIKit

enum RequestType: String {
    case getCaptcha
    case auth
    case getUserInfo
}

protocol APIProvider {
    func fetchData<T>(
        _ type: T.Type,
        requestType: RequestType,
        httpHeaders: [String : String]?,
        httpBody: Data?,
        complition: @escaping (Result<T?, Error>)->()
    ) where T: Codable
}

class APIProviderImpl: APIProvider {
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private let baseURL = "https://api-events.pfdo.ru/v1"
    
    private var getCaptchaUrl: String {
        return baseURL + "/captcha"
    }
    
    private var getAuthUrl: String {
        return baseURL + "/auth"
    }
    
    private var getUserInfoUrl: String {
        return baseURL + "/user"
    }
    
    private let session: URLSession = URLSession.shared
    
    func fetchData<T>(
        _ type: T.Type,
        requestType: RequestType,
        httpHeaders: [String : String]? = nil,
        httpBody: Data? = nil,
        complition: @escaping (Result<T?, Error>) -> ()
    ) where T: Codable {
        
        guard let url = URL(string: getUrl(for: requestType)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = getHTTPMethod(for: requestType).rawValue
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = httpBody
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: request) { (data, response, error) in
            guard
                let response = response as? HTTPURLResponse,
                let data = data,
                error == nil
            else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard response.statusCode == 200 else {
                do {
                    let ent = try decoder.decode(BadResponseModel.self, from: data)
                    self.showAlert(with: ent)
                    if let error = error {
                        complition(.failure(error))
                    }
                } catch {
                    complition(.failure(error))
                }
                return
            }
            
            do {
                let ent = try decoder.decode(type, from: data)
                complition(.success(ent))
            } catch {
                complition(.failure(error))
            }
        }.resume()
        
    }
    
    private func getUrl(for requestType: RequestType) -> String {
        switch requestType {
        case .auth:
            return getAuthUrl
        case .getCaptcha:
            return getCaptchaUrl
        case .getUserInfo:
            return getUserInfoUrl
        }
    }
    
    private func getHTTPMethod(for requestType: RequestType) -> HTTPMethod {
        switch requestType {
        case .auth:
            return .post
        case .getCaptcha:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    private func showAlert(with message: BadResponseModel) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if
                let _ = message.validation.password?.first,
                let _ = message.validation.username?.first
            {
                appDelegate?.showAlert(
                    title: "Ошибка",
                    message: "Неверный логин или пароль",
                    actionTitle: "Закрыть"
                )
            } else if let captchaError = message.validation.captcha?.first {
                appDelegate?.showAlert(
                    title: "Ошибка",
                    message: captchaError,
                    actionTitle: "Закрыть"
                )
            }
            
        }
    }
    
}
