//
//  DashboardModel.swift
//  Pharmacy
//
//  Created by A on 24/01/2022.
//

import Foundation

// MARK: - DashboardModel
struct DashboardModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: DashboardMessage?
}

// MARK: - Message
struct DashboardMessage: Codable {
    let employeeName, profileImage: String?
    let employeeTypeFk: Int?
    let employeeTypeFkLocalized: String?
    let totalDailyOrders: [TotalDailyOrder]?
    let totalDailyOrdersBranches: [TotalDailyOrdersBranch]?
    let branches: [Branch]?

    enum CodingKeys: String, CodingKey {
        case employeeName = "employeeName", profileImage = "profileImage", employeeTypeFk = "employeeTypeFk"
        case employeeTypeFkLocalized = "employeeTypeFk_Localized"
        case totalDailyOrders = "totalDailyOrders", totalDailyOrdersBranches = "totalDailyOrdersBranches", branches = "branches"
    }
}

// MARK: - Branch
struct Branch: Codable {
    let branchID: Int?
    let branchName: String?
    let ordersCount: Int?

    enum CodingKeys: String, CodingKey {
        case branchID = "branchId"
        case branchName = "branchName", ordersCount = "ordersCount"
    }
}

// MARK: - TotalDailyOrder
struct TotalDailyOrder: Codable {
    let type: String?
    let total: Int?
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case total = "total"
    }
}

// MARK: - TotalDailyOrdersBranch
struct TotalDailyOrdersBranch: Codable {
    let branchID: Int?
    let branchName: String?
    let totalDailyOrders: [TotalDailyOrder]?

    enum CodingKeys: String, CodingKey {
        case branchID = "branchId"
        case branchName = "branchName", totalDailyOrders = "totalDailyOrders"
    }
}
