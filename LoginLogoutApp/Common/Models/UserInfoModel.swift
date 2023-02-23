//
//  UserInfoModel.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import Foundation

struct UserInfoModel: Codable {
    let resultCode, resultMessage: String?
    let data: DataClass?
}

struct DataClass: Codable  {
    let id: Int?
    let username, createdAt: String?
    let status: Int?
    let isPfdoUser: Bool?
    let roles: [Municipality]?
    let profile: Profile?
    let certificate: Certificate?
    let timezone: String?
    let activeSystem: Int?
}

struct Certificate: Codable  {
    let id: Int?
    let certificateNumber: String?
}

struct Profile: Codable  {
    let email, phone, birthdayAt: String?
    let firstName, middleName, lastName, emailVerifiedAt: String?
    let name: String?
    let region, municipality: Municipality?
}

struct Municipality: Codable  {
    let id: Int?
    let name: String?
}
