//
//  String.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/03/2024.
//

import Foundation
import UIKit


extension String{
    var localized : String{
        let path = Bundle.main.path(forResource: AppLanguage.isArabic() ? "ar" : "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func formatPrice() -> String {
        if let priceDouble = Double(self)?.clean {
            return "\(priceDouble) \("kd".localized)"
        } else {
            return ""
        }
    }
    
    func isZeroPrice() -> Bool {
        if let price = Float(self) {
            return price == 0
        }
        return false
    }
    
    
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    func formatTime() -> (hours: String, amPm: String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: AppLanguage.currentAppleLanguage())
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "hh:mm"
            let hours = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "a"
            let amPm = dateFormatter.string(from: date)
            
            return (hours, amPm)
        } else {
            return nil
        }
    }
    
    
    func timeSlotFormatedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: AppLanguage.currentAppleLanguage().lowercased())
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "EEEE • dd/MM"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Int {
    func toString() -> String {
        return String(self)
    }
}
