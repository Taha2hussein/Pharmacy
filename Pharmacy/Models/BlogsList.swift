//
//  BlogsList.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import Foundation

// MARK: - BlogsList
struct BlogsList: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: [BlogMessage]?
}

// MARK: - Message
struct BlogMessage: Codable {
    var blogFilePath: String?
    var blogID: Int?
    var blogTitle: String?
    var isActive: Bool?
    var publisherType, likeCount: Int?
    var likeCountText, createDate: String?
    var shareLink: String?
    var amILiked: Bool?

    enum CodingKeys: String, CodingKey {
        case blogFilePath
        case blogID = "blogId"
        case blogTitle, isActive, publisherType, likeCount
        case likeCountText = "likeCount_Text"
        case createDate, shareLink, amILiked
    }
}
