//
//  LoginModel.swift
//  Pharmacy
//
//  Created by A on 18/01/2022.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    var token: String?
    var expiration: String?
    var apiresponseresult: Apiresponseresult?
}

// MARK: - Apiresponseresult
struct Apiresponseresult: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: LoginMessage?
}

// MARK: - Message
struct LoginMessage: Codable {
    var roleLst: [String]?
    var token: JSONNull?
    var doctorID, patientID, medicalRepID, businessProviderFk: Int?
    var pharmacistID, pharmacyProviderFk, pharmacistType, clubUserID: Int?

    enum CodingKeys: String, CodingKey {
        case roleLst, token
        case doctorID = "doctor_id"
        case patientID = "patient_id"
        case medicalRepID = "medicalRep_id"
        case businessProviderFk
        case pharmacistID = "pharmacist_id"
        case pharmacyProviderFk, pharmacistType
        case clubUserID = "clubUserId"
    }
}
