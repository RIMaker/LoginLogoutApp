//
//  APIProvider.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 22.02.2023.
//

import Foundation

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
        
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = getHTTPMethod(for: requestType).rawValue
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let places = try decoder.decode(type, from: data)
                complition(.success(places))
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
    
}
