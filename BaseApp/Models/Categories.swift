//
//  Categories.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import Foundation
public struct Categories: Codable {
    var categories: [Category]?
    var data: [Category]?
}

public struct SubCategories: Codable {
    var subcategories:[Category]?
}

// MARK: - Category
public struct Category: Codable, Equatable {
    let id, name, arName, productType: String?
    let mediaID: String?
    let imageURL: String?
    var isSelected:Bool = false
    var subcategories:[Category] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name, arName, productType, mediaID
        case imageURL = "imageUrl"
    }
    
    public init(id: String? = nil, name: String? = nil, arName: String? = nil, productType: String? = nil, mediaID: String? = nil, imageURL: String? = nil, isSelected: Bool = false, subcategories: [Category] = []) {
        self.id = id
        self.name = name
        self.arName = arName
        self.productType = productType
        self.mediaID = mediaID
        self.imageURL = imageURL
        self.isSelected = isSelected
        self.subcategories = subcategories
    }
    
    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
