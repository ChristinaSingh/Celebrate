//
//  ReplacementResponse.swift
//  BaseApp
//
//  Created by Ihab yasser on 05/12/2024.
//

import Foundation
public struct ReplacementRequest: Codable {
    let needReplacement: Bool?
    let applicationID: String?
    
    enum CodingKeys: String, CodingKey {
        case needReplacement = "need_replacement"
        case applicationID = "application_id"
    }
}
