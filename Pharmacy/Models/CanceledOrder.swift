////
////  CanceledOrder.swift
////  Pharmacy
////
////  Created by taha hussein on 08/03/2022.
////
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
    let offerFk, preescriptionFk: Int?
    let preescriptionDoctorID: Int?
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
    let offerData: JSONNull?
    let pharmacyOrderItem: [PharmacyOrderItem]?
    let currentOffer: CurrentOffer?
    let pharmacyOrderReview:String?
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
struct CurrentOffer: Codable {
    let pharmacyOrderOfferID, deliveryFees, deliveryTimeInMinuts: Int?
    let hasDelivery, isOnlinePayment: Bool?
    let offerDate: String?
    let offerendwithinminuts: Int?
    let offerNotes: String?
    let offerStatus: Int?
    let offerStatusLocalized: String?
    let orderDiscount, orderFees, orderTotalFees: Int?
    let orderitems: [Orderitem]?

    enum CodingKeys: String, CodingKey {
        case pharmacyOrderOfferID = "pharmacyOrderOfferId"
        case deliveryFees, deliveryTimeInMinuts, hasDelivery, isOnlinePayment, offerDate, offerendwithinminuts, offerNotes, offerStatus
        case offerStatusLocalized = "offerStatus_Localized"
        case orderDiscount, orderFees, orderTotalFees, orderitems
    }
}

// MARK: - Orderitem
struct Orderitem: Codable {
    let pharmacyOrderOfferItemID: Int?
    let medicationnameLocalized: String?
    let medicationFk, medicineType, medicineCategoryFk: Int?
    let medicineImagePathMobile: String?
    let priceType: Int?
    let isAlternative, isAvaliable: Bool?
    let quantity, pharmacyOrderItemFk, itemFees, baseItemMedicationFk: Int?
    let baseMedicationnameLocalized: String?

    enum CodingKeys: String, CodingKey {
        case pharmacyOrderOfferItemID = "pharmacyOrderOfferItemId"
        case medicationnameLocalized = "medicationname_Localized"
        case medicationFk, medicineType, medicineCategoryFk, medicineImagePathMobile, priceType, isAlternative, isAvaliable, quantity, pharmacyOrderItemFk, itemFees, baseItemMedicationFk
        case baseMedicationnameLocalized = "baseMedicationname_Localized"
    }
}

// MARK: - CancelorderDetails
struct CancelorderDetails: Codable {
    let reasonfk: Int?
    let reason, reasontype: String?
}

// MARK: - PharmacyOrderItem
struct PharmacyOrderItem: Codable {
    let pharmacyOrderItemID, itemFees, medicationFk: Int?
    let medicationNameLocalized: String?
    let priceType, medicineCategoryFk, medicineType, quantity: Int?
    let strenghtValue, medicineTypeNameLocalized, strenghtNameLocalized, formNameLocalized: String?
    let amountDetailsLocalized: String?
    let prescriptionData: PrescriptionData?

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
