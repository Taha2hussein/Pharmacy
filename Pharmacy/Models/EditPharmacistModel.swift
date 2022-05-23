//
//  EditPharmacistModel.swift
//  Pharmacy
//
//  Created by taha hussein on 20/04/2022.
//

import Foundation
// MARK: - EditPharmacistModel
struct EditPharmacistModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: EditPharmacistMessage?
}

// MARK: - Message
struct EditPharmacistMessage: Codable {
    var image, firstNameEn, firstNameAr, lastNameEn: String?
    var lastNameEAr, nameLocalized, email, mobileCode: String?
    var mobileNumber: String?
    var dateOfBirth: String?
    var gender, type: Int?
    var typeLocalized: String?
    var branches: [EditPharmacistBranch]?

    enum CodingKeys: String, CodingKey {
        case image, firstNameEn, firstNameAr, lastNameEn, lastNameEAr, nameLocalized, email, mobileCode, mobileNumber, dateOfBirth, gender, type
        case typeLocalized = "type_Localized"
        case branches
    }
}

// MARK: - Branch
struct EditPharmacistBranch: Codable {
    var branchID: Int?
    var branchName, cityName, address: String?
}
