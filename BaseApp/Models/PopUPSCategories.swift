//
//  PopUPSCategories.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/11/2024.
//

import Foundation
public struct PopUPSCategories: Codable {
    let status: Bool?
    let message: String?
    let data: [PopUPSCategory]?
    
    init(status: Bool? = nil, message: String? = nil, data: [PopUPSCategory]? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}


public struct PopUPSubSCategories: Codable {
    let status: Bool?
    let message: String?
    let data: [PopUpSubCategory]?
    
    init(status: Bool? = nil, message: String? = nil, data: [PopUpSubCategory]? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

public struct PopUpSubCategory: Codable {
    
    let id, name, arName, status: String?
    let productType, mediaID, displayorder, parentID: String?
    let pendingOrderApproval, avgprice, allowBundle, isReservation: String?
    let desc, descAr, imageType: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case arName = "ar_name"
        case status
        case productType = "product_type"
        case mediaID = "media_id"
        case displayorder
        case parentID = "parent_id"
        case pendingOrderApproval = "pending_order_approval"
        case avgprice
        case allowBundle = "allow_bundle"
        case isReservation = "is_reservation"
        case desc
        case descAr = "desc_ar"
        case imageType = "image_type"
    }
    
    
    init(id: String?, name: String?, arName: String?, status: String?, productType: String?, mediaID: String?, displayorder: String?, parentID: String?, pendingOrderApproval: String?, avgprice: String?, allowBundle: String?, isReservation: String?, desc: String?, descAr: String?, imageType: String?) {
        self.id = id
        self.name = name
        self.arName = arName
        self.status = status
        self.productType = productType
        self.mediaID = mediaID
        self.displayorder = displayorder
        self.parentID = parentID
        self.pendingOrderApproval = pendingOrderApproval
        self.avgprice = avgprice
        self.allowBundle = allowBundle
        self.isReservation = isReservation
        self.desc = desc
        self.descAr = descAr
        self.imageType = imageType
    }
    
}

// MARK: - Datum
public struct PopUPSCategory: Codable {
    let id, name, arName: String?
    let status: Qty?
    let productType: String?
    let mediaID: String?
    let displayorder, parentID, pendingOrderApproval, avgprice: String?
    let allowBundle, isReservation, desc, descAr: String?
    let imageType: String?
    let imageUrl:String?
    var isSelected:Bool = false
    var isFriendObject:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case arName = "ar_name"
        case status
        case productType = "product_type"
        case mediaID = "media_id"
        case displayorder
        case parentID = "parent_id"
        case pendingOrderApproval = "pending_order_approval"
        case avgprice
        case allowBundle = "allow_bundle"
        case isReservation = "is_reservation"
        case desc
        case descAr = "desc_ar"
        case imageType = "image_type"
        case imageUrl
    }
    
    init(id: String?, name: String?, arName: String?, status: Qty?, productType: String?, mediaID: String?, displayorder: String?, parentID: String?, pendingOrderApproval: String?, avgprice: String?, allowBundle: String?, isReservation: String?, desc: String?, descAr: String?, imageType: String?, imageUrl:String?, isFriendObject:Bool = false) {
        self.id = id
        self.name = name
        self.arName = arName
        self.status = status
        self.productType = productType
        self.mediaID = mediaID
        self.displayorder = displayorder
        self.parentID = parentID
        self.pendingOrderApproval = pendingOrderApproval
        self.avgprice = avgprice
        self.allowBundle = allowBundle
        self.isReservation = isReservation
        self.desc = desc
        self.descAr = descAr
        self.imageType = imageType
        self.imageUrl = imageUrl
        self.isFriendObject = isFriendObject
    }
}
