//
//  DashboardModel.swift
//  Pharmacy
//
//  Created by A on 24/01/2022.
//

import Foundation

// MARK: - DashboardModel
struct DashboardModel: Codable {
    var successtate: Int?
    var errormessage: JSONNull?
    var message: dashboardMessage?
}

// MARK: - Message
struct dashboardMessage: Codable {
    var employeeName, profileImage: String?
    var employeeTypeFk: Int?
    var employeeTypeFkLocalized: String?
    var totalDailyOrders: JSONNull?
    var totalDailyOrdersBranches: [TotalDailyOrdersBranch]?
    var branches: [Branch]?

    enum CodingKeys: String, CodingKey {
        case employeeName, profileImage, employeeTypeFk
        case employeeTypeFkLocalized = "employeeTypeFk_Localized"
        case totalDailyOrders, totalDailyOrdersBranches, branches
    }
}

// MARK: - Branch
struct Branch: Codable {
    var branchID: Int?
    var branchName: String?
    var ordersCount: Int?

    enum CodingKeys: String, CodingKey {
        case branchID = "branchId"
        case branchName, ordersCount
    }
}

// MARK: - TotalDailyOrdersBranch
struct TotalDailyOrdersBranch: Codable {
    var branchID: Int?
    var branchName: String?
    var totalDailyOrders: JSONNull?

    enum CodingKeys: String, CodingKey {
        case branchID = "branchId"
        case branchName, totalDailyOrders
    }
}
