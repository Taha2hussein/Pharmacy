//
//  AllBranchesModle.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation

// MARK: - AllBranchesModel
struct AllBranchesModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: AllBranchesModleMessage?
}

// MARK: - Message
struct AllBranchesModleMessage: Codable {
    let branches: [AllBranchesBranch]?
}

// MARK: - Branch
struct AllBranchesBranch: Codable {
    let branchID: Int?
    let branchName: String?
}
