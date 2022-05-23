//
//  FilterCatogryModel.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//

import Foundation
import Foundation

// MARK: - FilterCatogryModel
struct FilterCatogryModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: [FilterCatogrMessage]?
}

// MARK: - Message
struct FilterCatogrMessage: Codable {
    let id: Int?
    let categoryName: String?
}
