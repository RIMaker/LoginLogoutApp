//
//  Captcha.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

struct AuthResponseModel: Codable {
    let resultCode: String
    let resultMessage: String
    let data: AuthTokens
}

struct AuthTokens: Codable {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
    let refreshToken: String
}
