//
//  WalletTransactionList.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import Foundation
// MARK: - WalletTransactionList
struct WalletTransactionList: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [walletTransactionMessage]?
}

// MARK: - Message
struct walletTransactionMessage: Codable {
    var pharmacyWaletID, pharmacyFk, pharmacyBranchFk: Int?
    var balanceBefore: Double?
    var amount: Double?
    var balanceAfter: Double?
    var factor, transactionType, paymentType: Int?
    var orderFk: Int?
    var orderNum, transactionDate: String?
    var currencyFk: Int?
    var createDate, patientName, pharmacyName, transactionTypeName: String?
    var paymentTypeName, patientMobile: String?

    enum CodingKeys: String, CodingKey {
        case pharmacyWaletID = "pharmacyWaletId"
        case pharmacyFk, pharmacyBranchFk, balanceBefore, amount, balanceAfter, factor, transactionType, paymentType, orderFk, orderNum, transactionDate, currencyFk, createDate, patientName, pharmacyName, transactionTypeName, paymentTypeName, patientMobile
    }
}
