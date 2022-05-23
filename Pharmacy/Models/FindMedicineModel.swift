//
//  FindMedicineModel.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//

import Foundation
// MARK: - FindMedicinModel
struct FindMedicinModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: FindMedicineMessage?
}

// MARK: - Message
struct FindMedicineMessage: Codable {
    var medicines: [Medicine]?
    var advertisments: JSONNull?
    var cartCount, cartTtalFees: Int?
}

// MARK: - Medicine
struct Medicine: Codable {
    var medicationID: Int?
    var nameLocalized, medicineTypeNameLocalized: String?
    var medicineType: Int?
    var medicineImagePath: String?
    var medicineFormFk: Int?
    var medicineStrenghtFk: Int?
    var strenghtValue, companyFk, medicineCategoryFk: Int?
    var medicineCategoryName: String?
    var price: Double?
    var medicineForm, medicineStrenght: String?
    var advertisements: JSONNull?
    var medicineAmountDetailsLocalizeds: String? = "1"
    var numberOfCart, priceType: Int?

    enum CodingKeys: String, CodingKey {
        case medicationID = "medicationId"
        case nameLocalized = "name_Localized"
        case medicineTypeNameLocalized = "medicineType_name_Localized"
        case medicineType, medicineImagePath, medicineFormFk, medicineStrenghtFk, strenghtValue, companyFk, medicineCategoryFk, medicineCategoryName, price, medicineForm, medicineStrenght, advertisements
//        case medicineAmountDetailsLocalized = "medicineAmountDetails_Localized"
        case numberOfCart, priceType
    }
}
