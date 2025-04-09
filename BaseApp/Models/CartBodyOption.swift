//
//  CartBodyOption.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import Foundation
struct CartBodyOption: Codable {
    let id: String?
    let values: [Values]?
}

enum Values: Codable {
    case bool(Bool)
    case string(String)
    case value(CartBodyValue)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(CartBodyValue.self) {
            self = .value(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Values.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .value(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - ValueClass
struct CartBodyValue: Codable {
    let id: String
    let qty: Int
}
