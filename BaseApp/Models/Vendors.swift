//
//  Vendors.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import Foundation
public struct Vendors: Codable {
    var vendors: [Vendor]?
}

// MARK: - Vendor
public struct Vendor: Codable {
    let id, name, nameAr, organization: String?
    let phone, mobile:String?
    let mediaID: String?
    let imageURL, coverimageURL: String?
    let tnc: String?
    let email, vendorDescription, isFeatured, isHibernating: String?
    let vendorArDescription: String?
    let rated: Rated?
    let gallerymedia: [String]?
    let isExhausted: Bool?
    var isSelected:Bool = false
    
    
    init(id: String? = nil, name: String? = nil, nameAr: String? = nil, organization: String? = nil, phone: String? = nil, mobile: String? = nil, mediaID: String? = nil, imageURL: String? = nil, coverimageURL: String? = nil, tnc: String? = nil, email: String? = nil, vendorDescription: String? = nil, isFeatured: String? = nil, isHibernating: String? = nil, rated: Rated? = nil, gallerymedia: [String]? = nil, isExhausted: Bool? = nil, isSelected: Bool = false, vendorArDescription: String? = nil) {
        self.id = id
        self.name = name
        self.nameAr = nameAr
        self.organization = organization
        self.phone = phone
        self.mobile = mobile
        self.mediaID = mediaID
        self.imageURL = imageURL
        self.coverimageURL = coverimageURL
        self.tnc = tnc
        self.email = email
        self.vendorDescription = vendorDescription
        self.isFeatured = isFeatured
        self.isHibernating = isHibernating
        self.rated = rated
        self.gallerymedia = gallerymedia
        self.isExhausted = isExhausted
        self.isSelected = isSelected
        self.vendorArDescription = vendorArDescription
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case organization, phone, mobile, mediaID
        case imageURL = "imageUrl"
        case coverimageURL = "coverimageUrl"
        case tnc, email
        case vendorDescription = "description"
        case isFeatured, isHibernating, rated, isExhausted, gallerymedia
        case vendorArDescription = "description_ar"
    }
}

// MARK: - Rated
public struct Rated: Codable {
    let rating: String?
}
