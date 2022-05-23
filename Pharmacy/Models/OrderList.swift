//
//  OrderList.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation

// MARK: - OrderListModel
struct OrderListModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [OrderListMessage]?
}

// MARK: - Message
struct OrderListMessage: Codable {
    var orderID: Int?
    var deliveryFees: Int?
    var orderDiscount, orderFees, orderTotalFees: Double?
    var hasDelivery, isOnlinePayment: Bool?
    var orderDate, orderNo: String?
    var orderNotes: String?
    var orderPickingUpTime: String?
    var orderStatus: Int?
    var orderStatusLocalized: String?
    var singleOrderStatus, patientAddressFk, patientFk: Int?
    var paymentType: Int?
    var paymentTypeLocalized: String?
    var preescriptionFk: Int?
    var addressLang, addressLat: Double?
    var patientName: String?
    var patientProfileImage, patientAddressLocalized: String?
    var patientMapAddress: String?
    var itemCount: Int?
    var lastStatusDate: String?
    var hasFixedFees: Bool?
    var totalRate: Int?
    var pharmacyBranchFk: Int?

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

enum OrderStatusLocalized: String, Codable {
    case new = "New"
}

enum PatientName: String, Codable {
    case fNameLName = "f name l name"
    case halimaReda = "halima reda"
    case mostafaIsmail = "Mostafa Ismail"
    case ramyPatientPatient = "ramy Patient Patient"
}

enum PaymentTypeLocalized: String, Codable {
    case cash = "cash"
    case empty = ""
}
