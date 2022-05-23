//
//  TotalDialyOrdersModel.swift
//  Pharmacy
//
//  Created by taha hussein on 20/03/2022.
//

import Foundation
// MARK: - TotalDialyOrdersModel
struct TotalDialyOrdersModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: TotalDialyOrdersMessage?
}

// MARK: - Message
struct TotalDialyOrdersMessage: Codable {
    let totalDailyOrders: [TotalDailyOrder]?
    let totalDailyOrdersBranches: [TotalDailyOrdersBranchs]?
}


// MARK: - TotalDailyOrdersBranch
struct TotalDailyOrdersBranchs: Codable {
    let branchID: Int?
    let branchName: String?
    let totalDailyOrders: [TotalDailyOrder]?

    enum CodingKeys: String, CodingKey {
        case branchID = "branchId"
        case branchName, totalDailyOrders
    }
}
