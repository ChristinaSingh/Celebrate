//
//  CelebrateAvaragePrice.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/10/2024.
//

import Foundation



public struct CelebrateAvaragePrice: Codable {
    let status: Bool?
    let message: String?
    let data: AvaragePrice?
    
    init(status: Bool? = nil, message: String? = nil, data: AvaragePrice? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
public struct AvaragePrice: Codable {
    let minAvgprice, totalAvgprice: Float?
    
    init(minAvgprice: Float? = nil, totalAvgprice: Float? = nil) {
        self.minAvgprice = minAvgprice
        self.totalAvgprice = totalAvgprice
    }

    enum CodingKeys: String, CodingKey {
        case minAvgprice = "min_avgprice"
        case totalAvgprice = "total_avgprice"
    }
}
