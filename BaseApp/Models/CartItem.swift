//
//  CartItem.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import Foundation
struct CartItem: Codable {
    let id: String?
    let product: CartProduct?
    let pendingOrderApproval:Int?
    let createdTime: String?
    let vendor: CartVendor?
    let productOption: [CartProductOption]?
    let resourceSlot: ResourceSlot?
    let amount:String?
    let actualAmount: String?
    let discountPercent:String?
    let advanceRequired, groupHash: String?
    let pendingItemStatus:PendingStatus?

    enum CodingKeys: String, CodingKey {
        case id, product, createdTime, vendor, resourceSlot, amount
        case actualAmount = "actual_amount"
        case advanceRequired, groupHash, productOption, pendingOrderApproval
        case pendingItemStatus = "pending_order_approval_status"
        case discountPercent = "voucher_discount_percent"
    }
}



// MARK: - Customer
struct Customer: Codable {
    let id, name: String?
}

// MARK: - DeliveryFees
struct DeliveryFees: Codable {
    let fees: [Fee]?
    let total: Double?
}

// MARK: - Fee
struct Fee: Codable {
    let productID :Int?
    let fee: Double?
}

enum PendingStatus:String , Codable{
    case pending
    case approved_by_client
    case readyToPay
    case approved
    case cancelled_by_vendor
    
    func getStatus() -> String{
        switch self {
        case .pending:
            return "Pending".localized
        case .approved_by_client:
            return "Approved By Client".localized
        case .readyToPay:
            return "Ready To Pay".localized
        case .approved:
            return "Approved".localized
        case .cancelled_by_vendor:
            return "Cancelled By Vendor".localized
        }
    }
}

// MARK: - Product
struct CartProduct: Codable {
    let id, name , arName: String?
    let vendorID: String?
    let mediaID: String?
    let organization: String?
    let isyearly:String?
    let pendingApproval:String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case vendorID = "vendor_id"
        case mediaID = "media_id"
        case arName = "ar_name"
        case pendingApproval = "pending_order_approval"
        case organization , isyearly
    }
}

struct CartVendor: Codable {
    let id, name: String?
    let vendorID: String?
    let mediaID: String?
    let organization: String?
    let paymentmethod:Isyearly?

    enum CodingKeys: String, CodingKey {
        case id, name
        case vendorID = "vendor_id"
        case mediaID = "media_id"
        case organization, paymentmethod
    }
}
struct CartProductOption: Codable {
    let id:String?
    let name, type: String?
    let value: [Value]?
    let price: Double?
}

struct Value: Codable {
    let valueID:ValueID?
    let value: String?
    let qty: Qty?
}

enum ValueID: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ValueID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueID"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    var string : String {
        get{
            switch self {
            case .string(let string):
                return .init(string)
            default:
                return ""
            }
        }
        set {
            switch self{
            case .string:
                self = .string(newValue)
            default:
                break
            }
        }
    }
}

enum Qty: Codable {
    case integer(Int)
    case string(String)
    
    var string : String {
        get{
            switch self {
            case .string(let string):
                return .init(string)
            default:
                return ""
            }
        }
        set {
            switch self{
            case .string:
                self = .string(newValue)
            default:
                break
            }
        }
    }
    
    var integer : Int {
        get{
            switch self {
            case .integer(let string):
                return .init(string)
            default:
                return -1
            }
        }
        set {
            switch self{
            case .integer:
                self = .integer(newValue)
            default:
                break
            }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Qty.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Qty"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
// MARK: - ResourceSlot
struct ResourceSlot: Codable {
    let id, day, startTime, endTime: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, day
        case startTime = "start_time"
        case endTime = "end_time"
        case name
    }
    
    func toSlot() -> Slot {
        return Slot(id: id, day: day, startTime: startTime, endTime: endTime, maxOrder: nil, disabled: nil, preptimeNotAvailable: nil, availability: nil, consumed: nil, isSelected: false)
    }
}

// MARK: - Location
struct CartLocation: Codable {
    let locationID, locationName, governateName: String
}

// MARK: - WarnTime
struct WarnTime: Codable {
    let date: String
    let timezoneType: Int
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
}


