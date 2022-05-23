//
//  DeleteNotificationModel.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import Foundation

// MARK: - DeleteNotificationModel
struct DeleteNotificationModel: Codable {
    var successtate: Int?
    var errormessage, message: String?
}
