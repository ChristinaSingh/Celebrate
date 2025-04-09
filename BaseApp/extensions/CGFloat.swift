//
//  CGFloat.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
import UIKit


extension CGFloat {
    
    func relativeToIphone8Width(shouldUseLimit: Bool = true) -> CGFloat {
        let baseWidth: CGFloat = 430.0 // ihpone 15 pro max screen width
        let targetWidth: CGFloat = UIScreen.main.bounds.width
        return (UIScreen.main.bounds.width / baseWidth * targetWidth / UIScreen.main.bounds.width) * self
    }
    
    func relativeToIphone8Height(shouldUseLimit: Bool = true) -> CGFloat {
        let baseHeight: CGFloat = 932.0 // ihpone 15 pro max screen height
        let targetHeight: CGFloat = UIScreen.main.bounds.height
        return (UIScreen.main.bounds.height / baseHeight * targetHeight / UIScreen.main.bounds.height) * self
    }
    
}

extension Double {
    var clean: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: AppLanguage.currentAppleLanguage())
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
