//
//  PharmcyProfileModel.swift
//  Pharmacy
//
//  Created by taha hussein on 09/02/2022.
//

import Foundation
// MARK: - PharmacyProfileModel
struct PharmacyProfileModel: Codable {
    let successtate: Int
    let errormessage: String?
    let message: PharmayProfileMessage
}

// MARK: - Message
struct PharmayProfileMessage: Codable {
    let image, pharmacyName: String
    let branchesCount: Int
    let reviews: Double
    let reviewsDetails: [ReviewsDetail]
    let active: Bool
    let employeesList: [EmployeesList]
    let branchesList: [BranchesList]
}

// MARK: - BranchesList
struct BranchesList: Codable {
    let id: Int
    let branchName, cityName, address: String
    let isActive: Bool
}

// MARK: - EmployeesList
struct EmployeesList: Codable {
    let id: Int
    let employeeName, employeeType, employeeEmail, mobileCode: String
    let mobileNumber: String
    let type: Int
    let image: String
    let isActive: Bool
}

// MARK: - ReviewsDetail
struct ReviewsDetail: Codable {
    let rate: Int
    let evaluationTypeLocalized: String

    enum CodingKeys: String, CodingKey {
        case rate
        case evaluationTypeLocalized = "evaluationType_Localized"
    }
}
