//
//  Captcha.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

struct Captcha: Codable {
    let resultCode: String
    let resultMessage: String
    let data: CaptchaData
}

struct CaptchaData: Codable {
    let key: String
    let imageData: String
}
