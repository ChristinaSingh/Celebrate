//
//  AddBundleToCartBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/12/2024.
//

import Foundation
public struct AddBundleToCartBody: Codable {
    let cartID:String?
    let products:[CartBody]?
}
