//
//  RejectOrderModel.swift
//  Pharmacy
//
//  Created by taha hussein on 10/03/2022.
//

import Foundation

// MARK: - RejectOrder
struct RejectOrderModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: String?
}
