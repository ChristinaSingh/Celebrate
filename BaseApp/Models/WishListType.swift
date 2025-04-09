//
//  WishListType.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import Foundation


struct WishListType:Codable {
    
    let icon:String
    let title:String
    let subTitle:String
    var isSelected:Bool = false
}
