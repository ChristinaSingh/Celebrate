//
//  RoundedCornerTabBar.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit

class RoundedCornerTabBar: UITabBar {
    
    private let cornerRadius: CGFloat = 20.0
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        path.addClip()
        backgroundColor?.setFill()
        path.fill()
    }
    
    override var traitCollection: UITraitCollection {
        if #available(iOS 13.0, *) {
            return UITraitCollection(traitsFrom: [super.traitCollection, UITraitCollection(userInterfaceStyle: .light)])
        } else {
            return super.traitCollection
        }
    }
}

