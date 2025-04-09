//
//  ProductDetails.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import Foundation


public class ProductDetails: Codable {
    let id, name, arName: String?
    let vendor: ProductDetailsVendor?
    let productType, category: ProductDetailsCategory?
    let productDescription, arDescription, deliveryTime: String?
    let shippingApplied: Bool?
    let mediaID: String?
    let imageURL: String?
    var price, minPrice, advanceAmount: String?
    var extraImages: [ExtraImage]?
    let videos: [String]?
    let isQuantizable: String?
    let isyearly:Isyearly?
    let maxseats: String?
    let fromdate, todate: String?
    let seatsavailable: String?
    let cartCount: Int?
    var options: [Option]?
    let cancellationPolicy, arCancellationPolicy: String?
    let isResourceAvailable, prepTimeNotAvailable: Bool?
    let isLocationAvailable:Bool?
    let offerdetails: Offerdetails?
    let isFav:Int?
    let showseatsavailable:Int
    var isDescriptionCollapsed:Bool = false
    var isDurationCollapsed:Bool = false
    var isCancellationPolicyCollapsed:Bool = true
    var isDeliveryTimeCollapsed:Bool = false
    var requiresApproval:Bool = false
    var isItemExpanded:Bool = false
    
    init(id: String? = nil, name: String? = nil, arName: String? = nil, vendor: ProductDetailsVendor? = nil, productType: ProductDetailsCategory? = nil, category: ProductDetailsCategory? = nil, productDescription: String? = nil, arDescription: String? = nil, deliveryTime: String? = nil, shippingApplied: Bool? = nil, mediaID: String? = nil, imageURL: String? = nil, price: String? = nil, minPrice: String? = nil, advanceAmount: String? = nil, extraImages: [ExtraImage]? = nil, videos: [String]? = nil, isQuantizable: String? = nil, isyearly: Isyearly? = nil, maxseats: String? = nil, fromdate: String? = nil, todate: String? = nil, seatsavailable: String? = nil, cartCount: Int? = nil, options: [Option]? = nil, cancellationPolicy: String? = nil, arCancellationPolicy: String? = nil, isResourceAvailable: Bool? = nil, prepTimeNotAvailable: Bool? = nil, isLocationAvailable: Bool? = nil, offerdetails: Offerdetails? = nil, isFav: Int? = nil, showseatsavailable: Int = 0, isDescriptionCollapsed: Bool = false, isDurationCollapsed: Bool = false, isCancellationPolicyCollapsed: Bool = false, isDeliveryTimeCollapsed: Bool = false, isItemExpanded:Bool = false) {
        self.id = id
        self.name = name
        self.arName = arName
        self.vendor = vendor
        self.productType = productType
        self.category = category
        self.productDescription = productDescription
        self.arDescription = arDescription
        self.deliveryTime = deliveryTime
        self.shippingApplied = shippingApplied
        self.mediaID = mediaID
        self.imageURL = imageURL
        self.price = price
        self.minPrice = minPrice
        self.advanceAmount = advanceAmount
        self.extraImages = extraImages
        self.videos = videos
        self.isQuantizable = isQuantizable
        self.isyearly = isyearly
        self.maxseats = maxseats
        self.fromdate = fromdate
        self.todate = todate
        self.seatsavailable = seatsavailable
        self.cartCount = cartCount
        self.options = options
        self.cancellationPolicy = cancellationPolicy
        self.arCancellationPolicy = arCancellationPolicy
        self.isResourceAvailable = isResourceAvailable
        self.prepTimeNotAvailable = prepTimeNotAvailable
        self.isLocationAvailable = isLocationAvailable
        self.offerdetails = offerdetails
        self.isFav = isFav
        self.showseatsavailable = showseatsavailable
        self.isDescriptionCollapsed = isDescriptionCollapsed
        self.isDurationCollapsed = isDurationCollapsed
        self.isCancellationPolicyCollapsed = isCancellationPolicyCollapsed
        self.isDeliveryTimeCollapsed = isDeliveryTimeCollapsed
        self.isItemExpanded = isItemExpanded
    }

    enum CodingKeys: String, CodingKey {
        case id, name, arName, vendor, productType, category
        case productDescription = "description"
        case arDescription, deliveryTime, shippingApplied, mediaID
        case imageURL = "imageUrl"
        case videos , isLocationAvailable
        case cancellationPolicy = "cancellation_policy"
        case arCancellationPolicy = "ar_cancellation_policy"
        case price, minPrice, advanceAmount, extraImages, isQuantizable, cartCount, options , isResourceAvailable, prepTimeNotAvailable
        case offerdetails , isFav , isyearly, maxseats , fromdate, todate, seatsavailable, showseatsavailable
    }
}
enum Isyearly: Codable {
    case integer(Int)
    case string(String)

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
        throw DecodingError.typeMismatch(Isyearly.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Isyearly"))
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
}
// MARK: - Category
struct ProductDetailsCategory: Codable {
    let id, name, arName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case arName = "ar_name"
    }
}

// MARK: - ExtraImage
struct ExtraImage: Codable {
    let cloudinaryUUID: String?
    var url:String?
    var isSelected:Bool = false

    enum CodingKeys: String, CodingKey {
        case cloudinaryUUID = "cloudinary_uuid"
    }
}

// MARK: - Option
struct Option: Codable  {
    let id, name, optionDescription: String?
    let type, freeSelection, maxSelection:String?
    var minSelection: String?
    let arName : String?
    let price: String?
    let vMax:String?
    let optionRequired: Bool?
    var config: ConfigUnion?
    var isOptionCollapsed:Bool = false
    var isSelected:Bool = false
    func selectedCount() -> Int {
        self.config?.res?.filter{ $0.qty > 0 }.count ?? 0
    }
    
    func checkOptionsCount() -> Int {
        return self.config?.res?.filter{ $0.checked }.count ?? 0
    }
    
    func selectedQty() -> Int {
        var qty:Int = 0
        for configOption in self.config?.res ?? [] {
            qty += configOption.qty
        }
        return qty
    }
    var inputText:String = ""
    enum CodingKeys: String, CodingKey {
        case id, name, arName
        case optionDescription = "description"
        case type, freeSelection, maxSelection, minSelection, price, vMax
        case optionRequired = "required"
        case config
    }
}

enum ConfigUnion: Codable {
    case bool(Bool)
    case configArray([Config])
    
    var res : [Config]? {
        get{
            switch self {
            case .configArray(let arr):
                return .init(arr)
            default:
                return nil
            }
        }
        set {
            switch self{
            case .configArray:
                self = .configArray(newValue ?? res ?? [])
            default:
                break
            }
        }
    }
    
    var bool : Bool? {
        get{
            switch self {
            case .bool(let arr):
                return .init(arr)
            default:
                return nil
            }
        }
        
        set {
            switch self{
            case .bool:
                self = .bool(newValue ?? false)
            default:
                break
            }
        }
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode([Config].self) {
            self = .configArray(x)
            return
        }
        throw DecodingError.typeMismatch(ConfigUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ConfigUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .configArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - ConfigElement
struct Config: Codable {
    let id, name, arName, rate: String?
    let freeQty, maxQty, mediaID: String?
    let imageURL: String?
    var checked : Bool = false
    var qty:Int = 0{
        didSet{
            checked = qty > 0
        }
    }
    

    enum CodingKeys: String, CodingKey {
        case id, name, arName, rate, freeQty, maxQty, mediaID
        case imageURL = "imageUrl"
    }
}

// MARK: - Vendor
struct ProductDetailsVendor: Codable {
    let id, name, organization, mediaID: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, organization, mediaID
        case imageURL = "imageUrl"
    }
}

