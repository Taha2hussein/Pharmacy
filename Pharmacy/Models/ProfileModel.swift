//
//  ProfileModel.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: ProfileMessage?
}

// MARK: - Message
struct ProfileMessage: Codable {
    var image, firstNameEn, firstNameAr, lastNameEn: String?
    var lastNameEAr, nameLocalized, email, mobileCode: String?
    var mobileNumber: String?
    var dateOfBirth: String?
    var gender, type: Int?
    var typeLocalized: String?
    var branches: [PfofileBranch]?

    enum CodingKeys: String, CodingKey {
        case image, firstNameEn, firstNameAr, lastNameEn, lastNameEAr, nameLocalized, email, mobileCode, mobileNumber, dateOfBirth, gender, type
        case typeLocalized = "type_Localized"
        case branches
    }
}

// MARK: - Branch
struct PfofileBranch: Codable {
    var branchID: Int?
    var branchName, cityName, address: String?
}
