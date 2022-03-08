//
//  LogoutModel.swift
//  Pharmacy
//
//  Created by taha hussein on 12/02/2022.
//

import Foundation
// MARK: - LogoutModel
struct LogoutModel: Codable {
    let successtate: Int?
    let errormessage, message: String?
}
