//
//  Areas.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/08/2024.
//

import Foundation
public struct Area: Codable {
    let id, name, arName: String?
    var locations: [Area]?
    let governateID: String?
    var isExpanded:Bool = true

    enum CodingKeys: String, CodingKey {
        case id, name
        case arName = "ar_name"
        case locations
        case governateID = "governate_id"
    }
}

public typealias Areas = [Area]
