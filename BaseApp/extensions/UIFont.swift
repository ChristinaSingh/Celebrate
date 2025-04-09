//
//  UIFont.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
import UIKit


extension UIFont {
    func adapte() -> UIFont {
        let baseHeight: CGFloat = 932.0
        let heightMultiplier = UIScreen.main.bounds.height / baseHeight
        let adjustedSize = pointSize * max(heightMultiplier, 0.8)
//        if let font = UIFont(name: fontName, size: adjustedSize){
//            return font
//        }
        return UIFont.systemFont(ofSize: adjustedSize, weight: self.fontWeight)
    }
    
    var fontWeight: UIFont.Weight {
        guard let descriptor = fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] else {
            return .regular
        }
        
        if let weightNumber = descriptor[.weight] as? NSNumber {
            return UIFont.Weight(rawValue: CGFloat(weightNumber.doubleValue))
        }
        
        return .regular
    }
}
