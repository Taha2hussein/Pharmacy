//
//  MotificaitonListModel.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import Foundation
// MARK: - MotificaitonListModel
struct MotificaitonListModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [MotificaitonListMessage]?
}

// MARK: - Message
struct MotificaitonListMessage: Codable {
    var userNotificationID: Int?
    var loginUserID: String?
    var fromUserImageURL: String?
    var fromUserName: String?
//    var notificationDetails: NotificationTitle?
    var notificationTitle, notificationDetailsMessage, notificationDate: String?
    var notificationType, userTypeID: Int?
    var isRead: Bool?
    var forDoctorID: JSONNull?

    enum CodingKeys: String, CodingKey {
        case userNotificationID = "userNotificationId"
        case loginUserID = "loginUserId"
        case fromUserImageURL, fromUserName, notificationTitle,  notificationDetailsMessage, notificationDate, notificationType
        case userTypeID = "userTypeId"
        case isRead, forDoctorID
    }
}

enum NotificationTitle: String, Codable {
    case acceptOffer = "Accept Offer"
    case canceledOffer = "Canceled Offer"
    case newOrder = "New Order"
}
