//
//  BundleOptions.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/12/2024.
//

import Foundation
public struct BundleOptions: Codable {
    let status: Int?
    let message: String?
    let products: [ProductDetails]?
    
    
    init(status: Int?, message: String?, products: [ProductDetails]?) {
        self.status = status
        self.message = message
        self.products = products
    }
}
