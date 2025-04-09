//
//  Array+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//

import Foundation
extension Collection {
    func get(at index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func isLastIndex(_ index: Int) -> Bool {
        return index == self.count - 1
    }
}



extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            return (index >= 0 && index < count) ? self[index] : nil
        }
        set {
            if let newValue = newValue, index >= 0 && index < count {
                self[index] = newValue
            }
        }
    }
    
    func forEachIndexed(_ body: (Int, Element) -> Void) {
        for (index, element) in self.enumerated() {
            body(index, element)
        }
    }
}
extension Array {
    mutating func removeIfIndexExists(at index: Int) {
        if indices.contains(index) {
            remove(at: index)
        }
    }
}
extension Array {
    func canInsert(at index: Int) -> Bool {
        return index >= 0 && index <= self.count
    }
}
