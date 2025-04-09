//
//  CartBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import Foundation

public struct CartBody: Codable {
    var productID, resourceSlotID: String?
    var config: [CartBodyOption]?
    var cartID, deliveryDate, ocassionID, locationID: String?
    var addressid: String?
    var cartTime:String?
    var friendID:String?
    
    init(productID: String? = nil, resourceSlotID: String? = nil, config: [CartBodyOption]? = nil, cartID: String? = nil, deliveryDate: String? = nil, ocassionID: String? = nil, locationID: String? = nil, addressid: String? = nil, cartTime:String?, friendID:String?) {
        self.productID = productID
        self.resourceSlotID = resourceSlotID
        self.config = config
        self.cartID = cartID
        self.deliveryDate = deliveryDate
        self.ocassionID = ocassionID
        self.locationID = locationID
        self.addressid = addressid
        self.cartTime = cartTime
        self.friendID = friendID
    }
}
