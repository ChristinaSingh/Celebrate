//
//  Orders.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation
public struct Orders: Codable {
    let orders: [Order]?
    var hasMore:Bool {
        get { return orders?.isEmpty == false }
    }
    
    func ordersBy(category:OrderCategory? , orders:[Order]?) -> [Order]?{
        switch category {
        case .all:
            return orders
        case .paid:
            return orders?.filter{$0.status?.id == "2" && $0.substatus != "101"}
        case .confirmed:
            return orders?.filter{$0.status?.id == "2" && $0.substatus == "101"}
        case .completed:
            return orders?.filter{$0.status?.id == "3"}
        case .cancelled:
            return orders?.filter{$0.status?.id == "7" && !($0.refundStatus == "1" || $0.refundStatus == "2")}
        case .refunded:
            return orders?.filter{$0.status?.id == "7" && $0.refundStatus == "1"}
        case .popups:
            return orders?.filter { $0.orderType?.lowercased() == "popup_location" }
        case .none:
            return []
        }
    }
}

public struct Order: Codable {
    let id: String?
    let customer: Customer?
    let creationDate: String?
    let product: OrderProduct?
    let vendor: OrderVendor?
    let deliveryDate: String?
    let productOption: [OrderProductOption]?
    let resourceSlot: ResourceSlot?
    let status: Customer?
    let refundStatus, substatus: String?
    let orderRef, paymentMode, paymentStatus, deliveryFee: String?
    let amount: String?
    let rated: Rated?
    let advanceRequired: String?
    let location: AddressLocation?
    let address: OrderAddress?
    let isDeliveryAcknowledged: String?
    let deliveryAcknowledgeDate: String?
    let ocassion: Ocassion?
    let balance:String?
    let orderType: String?
    let friendFlag:Int?
    let trackid: String?
    let orderTime: String?

    enum CodingKeys: String, CodingKey {
        case id, customer, creationDate, product, vendor, deliveryDate, productOption, resourceSlot, status
        case refundStatus = "refund_status"
        case orderType = "order_type"
        case orderTime = "order_time"
        case substatus, orderRef, paymentMode, paymentStatus, deliveryFee, amount, rated, advanceRequired, location, address, isDeliveryAcknowledged, deliveryAcknowledgeDate, ocassion, balance, trackid , friendFlag
    }
    
    
    func orderCategory() -> OrderCategory{
        if status?.id == "2" && substatus != "101" {
            return .paid
        }
        
        if status?.id == "2" && substatus == "101"{
            return .confirmed
        }
        
        if status?.id == "3"{
            return .completed
        }
        
        if status?.id == "7" && !(refundStatus == "1" || refundStatus == "2"){
            return .cancelled
        }
        
        if status?.id == "7" && refundStatus == "1"{
            return .refunded
        }
        return .all
    }
}

struct OrderAddress: Codable {
    let name, area, block, street: String?
    let building:String?
    let floor, suitno, additionalDirection: String?
    let altNum:String?
    let additionalInfo: String?

    enum CodingKeys: String, CodingKey {
        case name, area, block, street, building, floor, suitno
        case additionalDirection = "additional_direction"
        case altNum = "alt_num"
        case additionalInfo = "additional_info"
    }
}

struct OrderVendor: Codable {
    let id, name, organization, mediaID: String?
    let cancellationPolicy, arCancellationPolicy: String?
    let phone, mobile: String?

    enum CodingKeys: String, CodingKey {
        case id, name, organization
        case mediaID = "media_id"
        case cancellationPolicy = "cancellation_policy"
        case arCancellationPolicy = "ar_cancellation_policy"
        case phone, mobile
    }
}

// MARK: - Ocassion
struct Ocassion: Codable {
    let id, name, asArName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case asArName = "as`arName"
    }
}

// MARK: - Product
struct OrderProduct: Codable {
    let id, name, vendorID:String?
    let mediaID: String?
    let cancellationPolicy, arCancellationPolicy: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case vendorID = "vendor_id"
        case mediaID = "media_id"
        case cancellationPolicy = "cancellation_policy"
        case arCancellationPolicy = "ar_cancellation_policy"
    }
}

struct OrderProductOption: Codable {
    let name, type: String?
    let value: [OrderValue]?
    let price: Double?
}

// MARK: - Value
struct OrderValue: Codable {
    let value: String?
    let qty: Qty?
}

struct AddressLocation: Codable {
    let locationID, locationName: String?
    let governateName: String?
    let arGovernateName: String?
    let arLocationName: String?
    
    enum CodingKeys: String, CodingKey {
        case locationID , locationName , governateName
        case arGovernateName = "ar_governateName"
        case arLocationName = "ar_locationName"
    }
}
