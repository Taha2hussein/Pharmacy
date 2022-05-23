//
//  RateModel.swift
//  Pharmacy
//
//  Created by taha hussein on 06/05/2022.
//

import Foundation

// MARK: - RateModel
struct RateModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: RateMessage?
}

// MARK: - Message
struct RateMessage: Codable {
    var image, pharmacyName: String?
    var totalRate, totalVisitors: Int?
    var rateDetails: [RateDetail]?
    var reviewList: [ReviewList]?
}

// MARK: - RateDetail
struct RateDetail: Codable {
    var rate: Int?
    var evaluationTypeLocalized: String?

    enum CodingKeys: String, CodingKey {
        case rate
        case evaluationTypeLocalized = "evaluationType_Localized"
    }
}

// MARK: - ReviewList
struct ReviewList: Codable {
    var orderNum: String?
    var patientID, pharmacyOrderReviewID: Int?
    var patientName, patientImage, reviewDate, notes: String?
    var reply, replyDate: String?
    var totalRate: Int?
    var hasComplaint: Bool?

    enum CodingKeys: String, CodingKey {
        case orderNum
        case patientID = "patientId"
        case pharmacyOrderReviewID = "pharmacyOrderReviewId"
        case patientName, patientImage, reviewDate, notes, reply, replyDate, totalRate, hasComplaint
    }
}
