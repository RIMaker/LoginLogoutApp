//
//  BadResponseModel.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

struct BadResponseModel: Codable {
    let resultCode: String
    let resultMessage: String
    let validation: Validation
}

struct Validation: Codable {
    let username: [String]?
    let password: [String]?
    let captcha: [String]?
}

