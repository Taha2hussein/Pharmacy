//
//  CanceledOrder.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation

// MARK: - CanceledOrder
struct CanceledOrder: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: CanceledOrderMessage?
}

// MARK: - Message
struct CanceledOrderMessage: Codable {
    let orderID: Int?
    let offerFk, preescriptionFk, preescriptionDoctorID: Int?
    let preescriptionDoctorName: String?
    let currentStatus: Int?
    let orderDate, orderLastDate, orderNo: String?
    let paymentType: Int?
    let paymentTypeLocalized: String?
    let isOnlinePayment, hasDelivery: Bool?
    let orderType: String?
    let patientID: Int?
    let patientName, patientProfileImage, patientEmail, patientMobile: String?
    let patientMobileCode: String?
    let patientGender, patientHeight, patientWeight: Int?
    let patientBirthDate: String?
    let patientAddreesID: Int?
    let patientAddressLocalized: String?
    let patientMapAddress, orderNotes: String?
    let pharmacyOrderFile: [JSONAny]?
    let offerData: JSONNull?
    let pharmacyOrderItem: [PharmacyOrderItem]?
    let cancelorderDetails: JSONNull?

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case offerFk, preescriptionFk
        case preescriptionDoctorID = "preescriptionDoctorId"
        case preescriptionDoctorName, currentStatus, orderDate, orderLastDate, orderNo, paymentType
        case paymentTypeLocalized = "paymentType_Localized"
        case isOnlinePayment, hasDelivery, orderType
        case patientID = "patientId"
        case patientName, patientProfileImage, patientEmail, patientMobile, patientMobileCode, patientGender, patientHeight, patientWeight, patientBirthDate
        case patientAddreesID = "patientAddreesId"
        case patientAddressLocalized = "patientAddress_Localized"
        case patientMapAddress, orderNotes, pharmacyOrderFile, offerData, pharmacyOrderItem, cancelorderDetails
    }
}

// MARK: - PharmacyOrderItem
struct PharmacyOrderItem: Codable {
    let pharmacyOrderItemID, itemFees, medicationFk: Int?
    let medicationNameLocalized: String?
    let priceType, medicineCategoryFk, medicineType, quantity: Int?
    let strenghtValue, medicineTypeNameLocalized, strenghtNameLocalized, formNameLocalized: String?
    let amountDetailsLocalized: String?
    let prescriptionData: JSONNull?

    enum CodingKeys: String, CodingKey {
        case pharmacyOrderItemID = "pharmacyOrderItemId"
        case itemFees, medicationFk
        case medicationNameLocalized = "medicationName_Localized"
        case priceType, medicineCategoryFk, medicineType, quantity, strenghtValue
        case medicineTypeNameLocalized = "medicineType_name_Localized"
        case strenghtNameLocalized = "strenghtName_Localized"
        case formNameLocalized = "formName_Localized"
        case amountDetailsLocalized = "amountDetails_Localized"
        case prescriptionData
    }
}
