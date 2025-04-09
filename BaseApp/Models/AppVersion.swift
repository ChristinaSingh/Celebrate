//
//  AppVersion.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/01/2025.
//

import Foundation
public struct AppVersion: Codable {
    let version: String?
    
    enum CodingKeys: String, CodingKey {
        case version = "iOS_version"
    }
}
