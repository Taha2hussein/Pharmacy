//
//  BlogDetails.swift
//  Pharmacy
//
//  Created by taha hussein on 12/02/2022.
//

import Foundation

// MARK: - BlogDetailsModel
struct BlogDetailsModel: Codable {
    let successtate: Int?
    let errormessage: String?
    let message: BlogDetailsMessage?
}

// MARK: - Message
struct BlogDetailsMessage: Codable {
    let blogFilePath: String?
    let blogID: Int?
    let blogText, blogTitle: String?
    let isActive: Bool?
    let publisherType, likeCount: Int?
    let likeCountText, createDate: String?
    let shareLink: String?
    let amILiked: Bool?

    enum CodingKeys: String, CodingKey {
        case blogFilePath
        case blogID = "blogId"
        case blogText, blogTitle, isActive, publisherType, likeCount
        case likeCountText = "likeCount_Text"
        case createDate, shareLink, amILiked
    }
}
