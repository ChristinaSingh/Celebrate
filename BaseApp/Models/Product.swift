//
//  Product.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import Foundation
public struct Product: Codable {
    let id, name, arName: String?
    let vendorID, categoryID, cancellationPolicy: String?
    let arCancellationPolicy, productDescription, arDescription, price: String?
    let vendorName, vendorNameAr, vendormediaID: String?
    var isResourceAvailable, prepTimeNotAvailable:Bool?
    let isLocationAvailable: Bool?
    let cartCount: Int?
    let imageURL: String?
    let vendorname, vendornameAr: String?
    let vendorimageURL: String?
    let isOffer: Bool?
    let requiresApproval:Bool?
    let offerPercent, offerPrice: String?
    var isFav:Int?
    let offerdetails: Offerdetails?
    let subcategoryID , mediaID:String?
    let maxseats , seatsavail:String?
    
    let deliveryTime: String?
    let shippingApplied: Bool?
    let extraImages: [ExtraImage]?
    let isQuantizable: String?
    let videos: [String]?
    let isyearly: Isyearly?
    let showseatsavailable: Int?
    var isGiftFav: Int?
    let options: [Option]?
    
    
    init(id: String? = nil, name: String? = nil, arName: String? = nil,  vendorID: String? = nil, categoryID: String? = nil, cancellationPolicy: String? = nil, arCancellationPolicy: String? = nil, productDescription: String? = nil, arDescription: String? = nil, price: String? = nil, vendorName: String? = nil, vendorNameAr: String? = nil, vendormediaID: String? = nil, isResourceAvailable: Bool? = nil, prepTimeNotAvailable: Bool? = nil, isLocationAvailable: Bool? = nil, cartCount: Int? = nil, imageURL: String? = nil, vendorname: String? = nil, vendornameAr: String? = nil, vendorimageURL: String? = nil, isOffer: Bool? = nil, requiresApproval: Bool? = nil, offerPercent: String? = nil, offerPrice: String? = nil, isFav: Int? = nil, offerdetails: Offerdetails? = nil, subcategoryID: String? = nil, mediaID: String? = nil, maxseats: String? = nil, seatsavail: String? = nil, deliveryTime: String? = nil, shippingApplied: Bool? = nil, extraImages: [ExtraImage]? = nil, isQuantizable: String? = nil, videos: [String]? = nil, isyearly: Isyearly? = nil, showseatsavailable: Int? = nil, options: [Option]? = nil, isGiftFav: Int? = nil) {
        self.id = id
        self.name = name
        self.arName = arName
        self.vendorID = vendorID
        self.categoryID = categoryID
        self.cancellationPolicy = cancellationPolicy
        self.arCancellationPolicy = arCancellationPolicy
        self.productDescription = productDescription
        self.arDescription = arDescription
        self.price = price
        self.vendorName = vendorName
        self.vendorNameAr = vendorNameAr
        self.vendormediaID = vendormediaID
        self.isResourceAvailable = isResourceAvailable
        self.prepTimeNotAvailable = prepTimeNotAvailable
        self.isLocationAvailable = isLocationAvailable
        self.cartCount = cartCount
        self.imageURL = imageURL
        self.vendorname = vendorname
        self.vendornameAr = vendornameAr
        self.vendorimageURL = vendorimageURL
        self.isOffer = isOffer
        self.requiresApproval = requiresApproval
        self.offerPercent = offerPercent
        self.offerPrice = offerPrice
        self.isFav = isFav
        self.offerdetails = offerdetails
        self.subcategoryID = subcategoryID
        self.mediaID = mediaID
        self.maxseats = maxseats
        self.seatsavail = seatsavail
        self.deliveryTime = deliveryTime
        self.shippingApplied = shippingApplied
        self.extraImages = extraImages
        self.isQuantizable = isQuantizable
        self.videos = videos
        self.isyearly = isyearly
        self.showseatsavailable = showseatsavailable
        self.options = options
        self.isGiftFav = isGiftFav
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, arName, vendorID, categoryID, subcategoryID
        case cancellationPolicy = "cancellation_policy"
        case arCancellationPolicy = "ar_cancellation_policy"
        case productDescription = "description"
        case arDescription, price, mediaID, vendorName
        case vendorNameAr = "vendorName_ar"
        case vendormediaID, isResourceAvailable, prepTimeNotAvailable, isLocationAvailable, cartCount
        case imageURL = "imageUrl"
        case vendorname
        case vendornameAr = "vendorname_ar"
        case vendorimageURL = "vendorimageUrl"
        case isOffer , offerdetails , isFav  , maxseats , seatsavail
        case requiresApproval = "pending_order_approval"
        case offerPercent = "offer_percent"
        case offerPrice = "offer_price"
        case deliveryTime, shippingApplied, extraImages, isQuantizable
        case videos, isyearly, showseatsavailable, options
        case isGiftFav
    }
    
    
    
}



public struct Offerdetails: Codable {
    let offerPercent, startdate, enddate, offerPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case offerPercent = "offer_percent"
        case startdate, enddate
        case offerPrice = "offer_price"
    }
}




public struct Products: Codable {
    var products: [Product]?
    let totalrecords: Int?
    let pagecount:Int?
}
