//
//  TimeSlots.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

// MARK: - TimeSlots
public struct TimeSlots: Codable {
    let status: Bool?
    let message: String?
    let data: [TimeSlot]?
    
    init(status: Bool? = nil , message: String? = nil , data: [TimeSlot]? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
public struct TimeSlot: Codable {
    let deliverytime: Qty?
    let displaytime: String?
    
    init(deliverytime: Qty? = nil, displaytime: String? = nil) {
        self.deliverytime = deliverytime
        self.displaytime = displaytime
    }
}

