//
//  Governorates.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/11/2024.
//

import Foundation

public struct Governorate: Codable {
    let id, name, arName, popupLocationDeliveryCharge: String?
    var isSelected:Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name
        case arName = "ar_name"
        case popupLocationDeliveryCharge = "popup_location_delivery_charge"
    }
    
    init(id: String?, name: String?, arName: String?, popupLocationDeliveryCharge: String?) {
        self.id = id
        self.name = name
        self.arName = arName
        self.popupLocationDeliveryCharge = popupLocationDeliveryCharge
    }
}

public typealias Governorates = [Governorate]
