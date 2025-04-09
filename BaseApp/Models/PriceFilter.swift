//
//  PriceFilter.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/06/2024.
//

import Foundation

enum PriceType{
    
    case AnyPrice
    case Under100
    case From100To200
    case Over200
    
    func rowValue() -> (from:String, to:String) {
        return switch self {
        case .AnyPrice:
            ("" , "")
        case .Under100:
            ("0" , "100")
        case .From100To200:
            ("100" , "200")
        case .Over200:
            ("200" , "1000000")
        }
    }
}


struct PriceFilter {
    let title:String
    let type:PriceType
    var isSelected:Bool = false
}
