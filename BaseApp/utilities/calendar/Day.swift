//
//  Day.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import Foundation
struct Day:Equatable {
    // 1
    let date: Date
    // 2
    let number: String
    
    let month:String
    
    let dayName:String
    
    var isToday:Bool = false
    
    var isSelected:Bool = false
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }
}
