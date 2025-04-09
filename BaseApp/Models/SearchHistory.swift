//
//  SearchHistory.swift
//  BaseApp
//
//  Created by Ihab yasser on 22/09/2024.
//

import Foundation

struct SearchHistory {
    let uuid: UUID
    let productId: String
    let searchTxt: String
    let img:String?
    var isHistory: Bool = true
    
    
    init(uuid: UUID, productId: String, searchTxt: String, img: String?, isHistory: Bool = true) {
        self.uuid = uuid
        self.productId = productId
        self.searchTxt = searchTxt
        self.img = img
        self.isHistory = isHistory
    }
}
