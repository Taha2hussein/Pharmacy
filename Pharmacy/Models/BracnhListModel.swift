//
//  BracnhListModel.swift
//  Pharmacy
//
//  Created by A on 25/01/2022.
//


import Foundation

// MARK: - BrnachListModel
struct BrnachListModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [BrahcnListMessage]?
}

// MARK: - Message
struct BrahcnListMessage: Codable {
    var pharmacyProviderBranchFk: Int?
    var entityNameLocalized, branchNameLocalized, branchAddressLocalized, branchLang: String?
    var branchLat, imagepath: String?
    var balanceBefore: Double?
    var totalIncome, totalExpense: Double?
    var totalBalance: Double?
    var incomePercentage, expensePercentage: Double?

    enum CodingKeys: String, CodingKey {
        case pharmacyProviderBranchFk
        case entityNameLocalized = "entityName_Localized"
        case branchNameLocalized = "branchName_Localized"
        case branchAddressLocalized = "branchAddress_Localized"
        case branchLang, branchLat, imagepath, balanceBefore, totalIncome, totalExpense, totalBalance, incomePercentage, expensePercentage
    }
}
