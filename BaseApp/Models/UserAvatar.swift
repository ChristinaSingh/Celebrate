//
//  UserAvatar.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
public class UserAvatar: Codable{
    let id, name: String?
    var imageURL: String?
    let status, createdAt, updatedAt: String?
    let sortorder: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sortorder
    }
    
    init(id: String?, name: String?, imageURL: String? = nil, status: String?, createdAt: String?, updatedAt: String?, sortorder: String?) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sortorder = sortorder
    }
    
}
