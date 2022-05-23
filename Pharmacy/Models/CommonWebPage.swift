//
//  CommonWebPage.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import Foundation
import Foundation

// MARK: - CommonWebPage
struct CommonWebPageModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [CommonWebPageMessage]?
}

// MARK: - Message
struct CommonWebPageMessage: Codable {
    var id: Int?
    var name: String?
    var url: String?
    var content: String?
}
