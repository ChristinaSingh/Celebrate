//
//  Banners.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//

import Foundation

public struct Banner: Codable {
    let id, name: String?
    let imageURL: String?
    let status: String?
    let createdAt, updatedAt: String?
    let hyperlink: String?
    let imageUrlAr:String?
    let hyperlinktype, productid, categoryid, vendorid: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrlAr = "imageUrl_ar"
        case imageURL = "imageUrl"
        case status, createdAt, updatedAt, hyperlink, hyperlinktype, productid, categoryid, vendorid
    }
}

public typealias Banners = [Banner]
