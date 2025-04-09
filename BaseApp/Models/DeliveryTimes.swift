//
//  DeliveryTimes.swift
//  BaseApp
//
//  Created by Ihab yasser on 05/05/2024.
//

import Foundation

public enum TimeSlotType{
    case AM
    case PM
}

public struct DeliveryTimes: Codable {
    let id, name, vendorID, maxOrderPerDay: String?
    var slots: [Slot]?
    var timeType:TimeSlotType = .AM
    
    enum CodingKeys: String, CodingKey {
        case id, name, vendorID, maxOrderPerDay
        case slots
    }
    
    
    func am() -> [Slot]?{
        return slots?.filter({ slot in
            slot.endTime?.formatTime()?.amPm.lowercased() == "am"
        })
    }
    
    func pm()-> [Slot]?{
        return slots?.filter({ slot in
            slot.endTime?.formatTime()?.amPm.lowercased() != "am"
        })
    }
}

// MARK: - Slot
public struct Slot: Codable {
    let id: String?
    let day: String?
    let startTime, endTime, maxOrder: String?
    var disabled: Int?
    let preptimeNotAvailable, availability: Bool?
    let consumed: Consumed?
    var isSelected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id , day , startTime , endTime , maxOrder
        case disabled, preptimeNotAvailable
        case availability , consumed
    }
}

public enum Consumed: Codable {
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Consumed.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Consumed"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
