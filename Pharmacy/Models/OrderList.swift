//
//  OrderList.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation

// MARK: - CanceledOrder
struct OrderList: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: [OrderListMessage]?
}

// MARK: - Message
struct OrderListMessage: Codable {
    let orderID, deliveryFees, orderDiscount, orderFees: Int?
    let orderTotalFees: Int?
    let hasDelivery, isOnlinePayment: Bool?
    let orderDate, orderNo: String?
    let orderNotes: String?
    let orderPickingUpTime: String?
    let orderStatus: Int?
    let orderStatusLocalized: String?
    let singleOrderStatus, patientAddressFk, patientFk, paymentType: Int?
    let paymentTypeLocalized: String?
    let preescriptionFk: String?
    let addressLang, addressLat: Double?
    let patientName, patientProfileImage, patientAddressLocalized: String?
    let patientMapAddress: JSONNull?
    let itemCount: Int?
    let lastStatusDate: String?
    let hasFixedFees: Bool?
    let totalRate, pharmacyBranchFk: Int?

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case deliveryFees, orderDiscount, orderFees, orderTotalFees, hasDelivery, isOnlinePayment, orderDate, orderNo, orderNotes, orderPickingUpTime, orderStatus
        case orderStatusLocalized = "orderStatus_Localized"
        case singleOrderStatus, patientAddressFk, patientFk, paymentType
        case paymentTypeLocalized = "paymentType_Localized"
        case preescriptionFk, addressLang, addressLat
        case patientName = "patient_name"
        case patientProfileImage
        case patientAddressLocalized = "patientAddress_Localized"
        case patientMapAddress, itemCount, lastStatusDate, hasFixedFees, totalRate, pharmacyBranchFk
    }
}
