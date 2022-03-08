//
//  ForgetPasswordFilrst.swift
//  Pharmacy
//
//  Created by taha hussein on 13/02/2022.
//

import Foundation

// MARK: - ForgetPasswordFirstModel
struct ForgetPasswordFirstModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: ForgetPasswordFirstMessage?
}

// MARK: - Message
struct ForgetPasswordFirstMessage: Codable {
    let message, tokencode: String?
}
