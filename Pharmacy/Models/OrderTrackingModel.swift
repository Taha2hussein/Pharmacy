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
    let patientGender: Int?
    let patientHeight, patientWeight: Int?
    let patientBirthDate: String?
    let patientAddreesID: Int?
    let patientAddressLocalized: String?
    let patientMapAddress: String?
    let orderNotes: String?
    let pharmacyOrderFile: [PharmacyOrderFile]?
    let offerData: String?
    let pharmacyOrderItem: [OrderTrackingPharmacyOrderItem]?
    let currentOffer: OrderTrackingCurrentOffer?
    let pharmacyOrderReview: String?
   let cancelorderDetails: CancelorderDetails?

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

// MARK: - CurrentOffer
struct OrderTrackingCurrentOffer: Codable {
    let pharmacyOrderOfferID: Int?
    let deliveryFees: Double?
    let deliveryTimeInMinuts: Int?
    let hasDelivery, isOnlinePayment: Bool?
    let offerDate: String?
    let offerendwithinminuts: Int?
    let offerNotes: String?
    let offerStatus: Int?
    let offerStatusLocalized: String?
    let orderDiscount, orderFees, orderTotalFees: Double?
    let orderitems: [Orderitem]?

    enum CodingKeys: String, CodingKey {
        case pharmacyOrderOfferID = "pharmacyOrderOfferId"
        case deliveryFees, deliveryTimeInMinuts, hasDelivery, isOnlinePayment, offerDate, offerendwithinminuts, offerNotes, offerStatus
        case offerStatusLocalized = "offerStatus_Localized"
        case orderDiscount, orderFees, orderTotalFees, orderitems
    }
}


// MARK: - PharmacyOrderFile
struct PharmacyOrderFile: Codable {
    let pharmacyOrderFileID: Int?
    let filePath: String?

    enum CodingKeys: String, CodingKey {
        case pharmacyOrderFileID = "pharmacyOrderFileId"
        case filePath
    }
}

// MARK: - PharmacyOrderItem
struct OrderTrackingPharmacyOrderItem: Codable {
    let pharmacyOrderItemID, medicationFk: Int?
    var itemFees: Double?
    let medicationNameLocalized: String?
    let priceType, medicineCategoryFk, medicineType, quantity: Int?
    var isAlternative: Bool?
    let strenghtValue, medicineTypeNameLocalized, strenghtNameLocalized, formNameLocalized: String?
    let amountDetailsLocalized: String?
    let prescriptionData: PrescriptionData?
    
    enum CodingKeys: String, CodingKey {
        case pharmacyOrderItemID = "pharmacyOrderItemId"
        case itemFees = "itemFees"
        case medicationFk = "medicationFk"
        case isAlternative = "isAlternative"
        case medicationNameLocalized = "medicationName_Localized"
        case priceType = "priceType"
        case medicineCategoryFk = "medicineCategoryFk"
        case medicineType = "medicineType"
        case quantity = "quantity"
        case strenghtValue = "strenghtValue"
        case medicineTypeNameLocalized = "medicineType_name_Localized"
        case strenghtNameLocalized = "strenghtName_Localized"
        case formNameLocalized = "formName_Localized"
        case amountDetailsLocalized = "amountDetails_Localized"
        case prescriptionData = "prescriptionData"
    }
}

// MARK: - PrescriptionData
struct PrescriptionData: Codable {
    let quantity: Int?
    let whenMedicationTakenNameLocalized: String?
    let durationValue: Int?
    let durationTypetNameLocalized: String?

    enum CodingKeys: String, CodingKey {
        case quantity
        case whenMedicationTakenNameLocalized = "whenMedicationTakenName_Localized"
        case durationValue
        case durationTypetNameLocalized = "durationTypetName_Localized"
    }
}
