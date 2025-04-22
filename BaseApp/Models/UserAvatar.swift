//
//  UserAvatar.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
public class avatar: Codable{
   
    let id, name: String?
    let imageUrl: String?
    let status, createdAt, updatedAt: String?
    let sortorder: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sortorder
    }
    
    init(id: String?, name: String?, imageUrl: String? = nil, status: String?, createdAt: String?, updatedAt: String?, sortorder: String?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sortorder = sortorder
    }
    
}
