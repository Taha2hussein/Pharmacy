//
//  WalletModel.swift
//  Pharmacy
//
//  Created by A on 25/01/2022.
//
import Foundation

// MARK: - WalletModel
struct WalletModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: walletMessage?
}

// MARK: - Message
struct walletMessage: Codable {
    var pharmacyProviderID: Int?
    var pharmacyName: String?
    var totalIncome: Double?
    var totalExpense, totalBalance, incomePercentage, expensePercentage: Double?

    enum CodingKeys: String, CodingKey {
        case pharmacyProviderID = "pharmacyProviderId"
        case pharmacyName, totalIncome, totalExpense, totalBalance, incomePercentage, expensePercentage
    }
}
