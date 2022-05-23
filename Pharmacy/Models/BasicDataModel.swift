//
//  BasicDataModel.swift
//  Pharmacy
//
//  Created by taha hussein on 23/04/2022.
//


import Foundation

// MARK: - BasicDataModel
struct BasicDataModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: BasicDataMessage?
}

// MARK: - Message
struct BasicDataMessage: Codable {
    var image, pharmacyNameEn, pharmacyNameAr: String?
    var timeToRespondTheOrderInHours: Int?
    var aboutThePharmacyAr, aboutThePharmacyEn: String?
    var files: [File]?
}

// MARK: - File
struct File: Codable {
    var filePath: String?
}
