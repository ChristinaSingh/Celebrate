//
//  Cart.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import Foundation
public struct Cart: Codable {
    let id: String?
    let customer: Customer?
    let creationTime, expiryTime: String?
    let warnTime: WarnTime?
    let location: CartLocation?
    let deliveryDate: String?
    let addressID: String?
    let cartType: CartType?
    let cartTime: String?
    let ocassionID: String?
    let cartTotal: Double?
    var items: [CartItem]?
    let paymentmethod:Isyearly?
    let deliveryFees: DeliveryFees?
    
    enum CodingKeys: String, CodingKey {
        case id
        case customer
        case creationTime
        case expiryTime
        case warnTime
        case location
        case deliveryDate
        case addressID
        case cartType = "cart_type"
        case cartTime = "cart_time"
        case ocassionID, cartTotal, items, paymentmethod, deliveryFees
    }
}


public typealias Carts = [Cart]
