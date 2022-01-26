//
//  DashboardBranchesList.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import Foundation

// MARK: - PharmacyDashboardBranches
struct PharmacyDashboardBranches: Codable {
    var successtate: Int?
    var errormessage: JSONNull?
    var message: PharmacyDashboardBranchesMessage?
}

// MARK: - Message
struct PharmacyDashboardBranchesMessage: Codable {
    var branches: [Branch]?
}

