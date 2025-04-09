//
//  Restaurant.swift
//  BaseApp
//
//  Created by Ihab yasser on 09/11/2024.
//

import Foundation


public struct Restaurant: Codable, Identifiable {
    public var id: String?
    public var name: String?
    public var nameAr: String?
    public var rating: String?
    public var vendorDescription: String?
    public var imageURL: String?
}
