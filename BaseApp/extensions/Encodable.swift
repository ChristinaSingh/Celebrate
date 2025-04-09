//
//  Encodable.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    
}
