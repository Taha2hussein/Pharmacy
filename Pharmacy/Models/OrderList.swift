//
//  OrderList.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation

// MARK: - OrderList
struct OrderList: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: [OrderListMessage]?
}

// MARK: - Message
struct OrderListMessage: Codable {
    let orderID: Int?
    let deliveryFees: Int?
    let orderDiscount, orderFees, orderTotalFees: Int?
    let hasDelivery, isOnlinePayment: Bool?
    let orderDate, orderNo: String?
    let orderNotes, orderPickingUpTime: String?
    let orderStatus: Int?
    let orderStatusLocalized: String?
    let singleOrderStatus, patientAddressFk, patientFk, paymentType: Int?
    let paymentTypeLocalized: String?
    let preescriptionFk: String?
    let addressLang, addressLat: Double?
    let patientName, patientProfileImage, patientAddressLocalized: String?
    let patientMapAddress: String?
    let itemCount: Int?
    let lastStatusDate: String?
    let hasFixedFees: Bool?
    let totalRate: Int?
    let pharmacyBranchFk: String?

    enum CodingKeys: String, CodingKey {
        case orderID
        case deliveryFees, orderDiscount, orderFees, orderTotalFees, hasDelivery, isOnlinePayment, orderDate, orderNo, orderNotes, orderPickingUpTime, orderStatus
        case orderStatusLocalized
        case singleOrderStatus, patientAddressFk, patientFk, paymentType
        case paymentTypeLocalized
        case preescriptionFk, addressLang, addressLat
        case patientName
        case patientProfileImage
        case patientAddressLocalized
        case patientMapAddress, itemCount, lastStatusDate, hasFixedFees, totalRate, pharmacyBranchFk
    }
}
