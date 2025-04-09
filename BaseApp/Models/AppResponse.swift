//
//  AppResponse.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/04/2024.
//

import Foundation
public struct AppResponse: Codable {
    let message: String?
    let status:Status?
    let data:String?
}

public struct PlanEventResponse: Codable {
    let message: String?
    let status:Status?
    let data:PlanEventRes?
}

public struct ReplacementResponse: Codable {
    let message: String?
    let status:Status?
}

struct PlanEventRes: Codable {
    let id: String?
}
enum Status: Codable {
    case int(Int)
    case string(String)
    case bool(Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else {
            throw DecodingError.typeMismatch(
                Status.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Status value is not of expected types (Int, String, Bool)"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        }
    }
    
    var boolean: Bool {
        if case .bool(let value) = self {
            return value
        }
        return false
    }
    
    var int: Int? {
        if case let .int(value) = self {
            return value
        }
        return nil
    }
    
    var string: String {
        if case let .string(value) = self {
            return value
        }
        return ""
    }
    
}
