//
//  BundleBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/11/2024.
//

import Foundation
public struct BundleBody: Codable {
    let subCategoriesInputs: [SubCategoriesInput]?
    let deliveryDate, occassions, categories, subcategories: String?
    let maxPrice: String?

    enum CodingKeys: String, CodingKey {
        case subCategoriesInputs = "sub_categories_inputs"
        case deliveryDate = "delivery_date"
        case occassions, categories, subcategories
        case maxPrice = "max_price"
    }
    
    init(subCategoriesInputs: [SubCategoriesInput]? = nil, deliveryDate: String? = nil, occassions: String? = nil, categories: String? = nil, subcategories: String? = nil, maxPrice: String? = nil) {
        self.subCategoriesInputs = subCategoriesInputs
        self.deliveryDate = deliveryDate
        self.occassions = occassions
        self.categories = categories
        self.subcategories = subcategories
        self.maxPrice = maxPrice
    }
}

// MARK: - SubCategoriesInput
public struct SubCategoriesInput: Codable {
    let subCategoryID, type, contentType: String?
    let value: String?

    enum CodingKeys: String, CodingKey {
        case subCategoryID = "sub_category_id"
        case type
        case contentType = "content_type"
        case value
    }
    
    
    init(subCategoryID: String? = nil, type: String? = nil, contentType: String? = nil, value: String? = nil) {
        self.subCategoryID = subCategoryID
        self.type = type
        self.contentType = contentType
        self.value = value
    }
}
