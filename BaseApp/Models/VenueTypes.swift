//
//  VenueTypes.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//


// MARK: - VenueTypes
public struct VenueTypes: Codable {
    let status: Bool?
    let message: String?
    let data: [VenueType]?
}

// MARK: - Datum
public struct VenueType: Codable {
    let id: Int?
    let name, nameAr: String?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
    }
}
