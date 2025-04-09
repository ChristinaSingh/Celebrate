//
//  CreateCartBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/12/2024.
//

import Foundation
public struct CreateCartBody: Codable {
    let ocassionID: String?
    let locationID, deliveryDate:String?
    let cartType: CartType?
    let popupLocationID: String?
    let popupLocationDate: PopupLocationDate?
    let addressID: String?
    let cartTime: String?
    let friendID: String?
    
    enum CodingKeys: String, CodingKey {
        case ocassionID, locationID, deliveryDate
        case cartType = "cart_type"
        case popupLocationID = "popup_location_id"
        case popupLocationDate = "popup_location_date"
        case addressID = "addressid"
        case cartTime = "cart_time"
        case friendID = "friend_id"
    }
}
