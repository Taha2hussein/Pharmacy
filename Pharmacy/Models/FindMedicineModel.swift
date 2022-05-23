//
//  FindMedicineModel.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//

import Foundation


// MARK: - FindMedicinModel
struct FindMedicinModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: FindMedicineMessage?
}

// MARK: - Message
struct FindMedicineMessage: Codable {
    let medicines: [Medicine]?
    let advertisments: JSONNull?
    let cartCount, cartTtalFees: Int?
}

// MARK: - Medicine
struct Medicine: Codable {
    let medicationID: Int?
    let nameLocalized: String?
    let medicineTypeNameLocalized: MedicineTypeNameLocalized?
    let medicineType: Int?
    let medicineImagePath: String?
    let medicineFormFk: Int?
    let medicineStrenghtFk, strenghtValue: Int?
    let companyFk, medicineCategoryFk: Int?
    let medicineCategoryName: String?
    let price: Int?
    let medicineForm, medicineStrenght: String?
    let advertisements: JSONNull?
    let medicineAmountDetailsLocalized: String?
    let numberOfCart, priceType: Int?

    enum CodingKeys: String, CodingKey {
        case medicationID = "medicationId"
        case nameLocalized = "name_Localized"
        case medicineTypeNameLocalized = "medicineType_name_Localized"
        case medicineType, medicineImagePath, medicineFormFk, medicineStrenghtFk, strenghtValue, companyFk, medicineCategoryFk, medicineCategoryName, price, medicineForm, medicineStrenght, advertisements
        case medicineAmountDetailsLocalized = "medicineAmountDetails_Localized"
        case numberOfCart, priceType
    }
}

enum MedicineTypeNameLocalized: String, Codable {
    case أخرى = "أخرى"
    case دواء = "دواء"
}
