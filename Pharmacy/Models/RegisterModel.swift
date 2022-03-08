//
//  RegisterModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: Message?
}

// MARK: - Message
struct Message: Codable {
    var tokenCode: String?
    var activateLink: String?
}
