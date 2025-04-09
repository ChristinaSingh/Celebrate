//
//  DineOut.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/11/2024.
//

import Foundation
import UIKit


struct DineOut {
    let title:String?
    let type:DineOutType?
    let desc:String?
    let image:UIImage?
    
    
    init(title: String? = nil, type: DineOutType? = nil, desc: String? = nil, image:UIImage? = nil) {
        self.title = title
        self.type = type
        self.desc = desc
        self.image = image
    }
}
