//
//  SearchType.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/04/2024.
//

import Foundation
enum SearchType : String{
    case Explore = "Explore"
    case Products = "Products"
    case Stores = "Stores"
    
    
    func localized() -> String {
        return self.rawValue.localized
    }
}
