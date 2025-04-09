//
//  OrderCategory.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation


enum OrderCategory{
    case all
    case paid
    case confirmed
    case completed
    case cancelled
    case refunded
    case popups
}

struct OrderCategoryModel {
    let title:String
    let category:OrderCategory
    var isSelected:Bool = false
}
