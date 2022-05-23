//
//  PharmacistProfileModel.swift
//  Pharmacy
//
//  Created by taha hussein on 24/04/2022.
//

import Foundation
// MARK: - PharmacistProfileModel
struct PharmacistProfileModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: PharmacistProfileMessage?
}

// MARK: - Message
struct PharmacistProfileMessage: Codable {
    var image, firstNameEn, firstNameAr, lastNameEn: String?
    var lastNameEAr, nameLocalized, email, mobileCode: String?
    var mobileNumber: String?
    var dateOfBirth: String?
    var gender, type: Int?
    var typeLocalized: String?
    var branches: [PharmacistProfileBranch]?

    enum CodingKeys: String, CodingKey {
        case image, firstNameEn, firstNameAr, lastNameEn, lastNameEAr, nameLocalized, email, mobileCode, mobileNumber, dateOfBirth, gender, type
        case typeLocalized = "type_Localized"
        case branches
    }
}

// MARK: - Branch
struct PharmacistProfileBranch: Codable {
    var branchID: Int?
    var branchName, cityName, address: String?
}
