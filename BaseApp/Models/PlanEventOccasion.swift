//
//  PlanEventOccasion.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//


public struct PlanEventOccasion: Codable {
    let id, name, nameAr: String?
    let imageURL, imageURLAr: String?
    var isSelected:Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case imageURL = "image_url"
        case imageURLAr = "image_url_ar"
    }
}

public typealias PlanEventOccasions = [PlanEventOccasion]
