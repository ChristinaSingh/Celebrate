//
//  Avatars.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/12/2024.
//

import Foundation
public struct AvatarResponse: Codable {
    let id, name: String?
    let imageURL: String?
    let status, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
        case status, createdAt, updatedAt
    }
}

public typealias Avatars = [AvatarResponse]?
