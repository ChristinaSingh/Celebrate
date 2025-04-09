//
//  Month.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import Foundation
struct Month {
    var days:[Day]
    let date:Date
    let monthName:String
    var isSelected:Bool = false
}

struct MonthMetadata {
  let numberOfDays: Int
  let firstDay: Date
  let firstDayWeekday: Int
}
