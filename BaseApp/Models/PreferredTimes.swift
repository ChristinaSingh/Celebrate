//
//  PreferredTimes.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/09/2024.
//

import Foundation
public struct PreferredTime: Codable {
    let preftimeid, fromtime, totime: String?
    let blocked: Bool?
    let displaytext: String?
    var isSelected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case fromtime, totime, blocked, displaytext, preftimeid
    }
}

public typealias PreferredTimes = [PreferredTime]
