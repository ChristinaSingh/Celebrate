//
//  Planners.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import Foundation
public struct Planner: Codable {
    let id, name, nameAr: String?
    let iconURL, coverpageURL: String?
    let rating: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case iconURL = "icon_url"
        case coverpageURL = "coverpage_url"
        case rating
    }
}

public typealias Planners = [Planner]
