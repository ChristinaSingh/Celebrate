//
//  VenueHotels.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//

import Foundation

public struct VenueHotels: Codable {
    let status: Bool?
    let message: String?
    let data: [VenueHotel]?
}

// MARK: - Datum
public struct VenueHotel: Codable {
    let id, nameAr, nameEn: String?
    let image: String?
    let isActive: String?
    var isSelected:Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case image
        case isActive = "is_active"
    }
}
