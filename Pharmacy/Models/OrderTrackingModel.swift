//
//  OrderTrackingModel.swift
//  Pharmacy
//
//  Created by taha hussein on 09/03/2022.
//

import Foundation

// MARK: - OrderTrackingModel
struct OrderTrackingModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: OrderTrackingMessage?
}

// MARK: - Message
struct OrderTrackingMessage: Codable {
    let orderID: Int?
    let offerFk, preescriptionFk, preescriptionDoctorID: JSONNull?
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
    let patientGender: Int?
    let patientHeight, patientWeight: Int?
    let patientBirthDate: String?
    let patientAddreesID: Int?
    let patientAddressLocalized: String?
    let patientMapAddress: String?
    let orderNotes: String?
    let pharmacyOrderFile: [JSONAny]?
    let offerData: String?
    let pharmacyOrderItem: [OrderTrackingPharmacyOrderItem]?
    let currentOffer, pharmacyOrderReview, cancelorderDetails: String?

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
        case patientMapAddress, orderNotes, pharmacyOrderFile, offerData, pharmacyOrderItem, currentOffer, pharmacyOrderReview, cancelorderDetails
    }
}

// MARK: - PharmacyOrderItem
struct OrderTrackingPharmacyOrderItem: Codable {
    let pharmacyOrderItemID, itemFees, medicationFk: Int?
    let medicationNameLocalized: String?
    let priceType, medicineCategoryFk, medicineType, quantity: Int?
    let strenghtValue, medicineTypeNameLocalized, strenghtNameLocalized, formNameLocalized: String?
    let amountDetailsLocalized: String?
    let prescriptionData: String?

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
