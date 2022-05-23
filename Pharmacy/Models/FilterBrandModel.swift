//
//  FilterBrandModel.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//

import Foundation
// MARK: - FilterBrandModel
struct FilterBrandModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: [FilterBrandMessage]?
}

// MARK: - Message
struct FilterBrandMessage: Codable {
    let id: Int?
    let companyName: String?
    let image: String?
}
