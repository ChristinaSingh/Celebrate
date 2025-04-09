//
//  Occasions.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

public struct Occasions: Codable {
    let status: Bool?
    let message: String?
    var data: Occasion?
    
    init(status: Bool? = nil, message: String? = nil, data: Occasion? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
public struct Occasion: Codable {
    var ocassions: [CelebrateOcassion]?
    
    init(ocassions: [CelebrateOcassion]? = nil) {
        self.ocassions = ocassions
    }
}

// MARK: - Ocassion
public struct CelebrateOcassion: Codable {
    let id, name, arName, mediaID: String?
    let imageURL: String?
    let extraImages: [String]?
    var isSelected:Bool = false
    
    init(id: String? = nil, name: String? = nil, arName: String? = nil, mediaID: String? = nil, imageURL: String? = nil, extraImages: [String]? = nil) {
        self.id = id
        self.name = name
        self.arName = arName
        self.mediaID = mediaID
        self.imageURL = imageURL
        self.extraImages = extraImages
    }

    enum CodingKeys: String, CodingKey {
        case id, name, arName, mediaID
        case imageURL = "imageUrl"
        case extraImages
    }
}
