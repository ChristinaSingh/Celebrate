//
//  ApplePayTabResponse.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
struct ApplePayTabResponse: Codable {
    let data, signature: String?
    let header: Header?
    let version: String?
}

// MARK: - Header
struct Header: Codable {
    let publicKeyHash, ephemeralPublicKey, transactionID: String?

    enum CodingKeys: String, CodingKey {
        case publicKeyHash, ephemeralPublicKey
        case transactionID = "transactionId"
    }
}
