//
//  CancelReasons.swift
//  Pharmacy
//
//  Created by taha hussein on 10/03/2022.
//

import Foundation

// MARK: - CancelReasons
struct CancelReasons: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: [CancelReasonsMessage]?
}

// MARK: - Message
struct CancelReasonsMessage: Codable {
    let cancellationReasonID: Int?
    let cancellationReasonNameLocalized: String?

    enum CodingKeys: String, CodingKey {
        case cancellationReasonID = "cancellationReasonId"
        case cancellationReasonNameLocalized = "cancellationReasonName_Localized"
    }
}
