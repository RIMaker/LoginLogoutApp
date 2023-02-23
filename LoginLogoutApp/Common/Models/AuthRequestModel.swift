//
//  AuthRequestModel.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

struct AuthRequestModel: Codable {
    let username: String
    let password: String
    let captcha: CaptchaRequestData
}

struct CaptchaRequestData: Codable {
    let key: String
    let value: String
}
