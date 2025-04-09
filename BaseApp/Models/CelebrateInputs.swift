//
//  CelebrateInputs.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/10/2024.
//

import Foundation
// MARK: - CelebrateInputs
public struct CelebrateInputs: Codable {
    let status: Bool?
    let message: String?
    let data: CelebrateInput?
    
    
    public init(status: Bool? = nil, message: String? = nil, data: CelebrateInput? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
public struct CelebrateInput: Codable {
    let subCategories: [SubCategory]?

    init(subCategories: [SubCategory]? = nil) {
        self.subCategories = subCategories
    }
    
    enum CodingKeys: String, CodingKey {
        case subCategories = "sub_categories"
    }
}

// MARK: - SubCategory
public struct SubCategory: Codable {
    let id, name: String?
    let arName: String?
    let imageURL: String?
    let inputs: [Input]?
    
    
    init(id: String? = nil, name: String? = nil, arName: String? = nil, imageURL: String? = nil, inputs: [Input]? = nil) {
        self.id = id
        self.name = name
        self.arName = arName
        self.imageURL = imageURL
        self.inputs = inputs
    }

    enum CodingKeys: String, CodingKey {
        case id, name, arName
        case imageURL = "imageUrl"
        case inputs
    }
}

// MARK: - Input
public struct Input: Codable {
    let id, name, arName: String?
    let type:String?
    let contentType: String?
    var subCatId:String? = nil
    var value:String? = nil
    
    init(id: String? = nil, name: String? = nil, arName: String? = nil, type: String? = nil, contentType: String? = nil) {
        self.id = id
        self.name = name
        self.arName = arName
        self.type = type
        self.contentType = contentType
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case arName = "ar_name"
        case type
        case contentType = "content_type"
    }
}

public enum InputType: String, Codable {
    case INPT = "INPT"
}

public enum InputContentType: String, Codable {
    case number = "number"
    case text = "text"
}
