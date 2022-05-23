//
//  FAQModel.swift
//  Pharmacy
//
//  Created by taha hussein on 15/05/2022.
//

import Foundation
// MARK: - SaveReplayModel
struct FAQModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [FAQMessage]?
}

// MARK: - Message
struct FAQMessage: Codable {
    var helpsupportID: Int?
    var helpsupportNameAr, helpsupportNameEn, helpsupportAnswerAr, helpsupportAnswerEn: String?
    var createDate, nameLocalized, helpsupportAnswerLocalized: String?

    enum CodingKeys: String, CodingKey {
        case helpsupportID = "helpsupportId"
        case helpsupportNameAr, helpsupportNameEn, helpsupportAnswerAr, helpsupportAnswerEn, createDate
        case nameLocalized = "name_Localized"
        case helpsupportAnswerLocalized = "helpsupportAnswer_Localized"
    }
}
