//
//  Bundles.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import Foundation
public struct BundlesResponse: Codable {
    let message: String?
    let bundles: [AIBundle]?
}

struct AIBundle: Codable {
    let products: [Product]?
    let totalPrice: Double?
    let highlight: Bool?
}
