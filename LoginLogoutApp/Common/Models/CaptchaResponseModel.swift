//
//  Captcha.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

struct CaptchaResponseModel: Codable {
    let resultCode: String
    let resultMessage: String
    let data: CaptchaResponseData
}

struct CaptchaResponseData: Codable {
    let key: String
    let imageData: String
}
