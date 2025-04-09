//
//  UIView+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import Foundation
import UIKit

extension UIView{
    func applyLinearGradient(colors: [CGColor] , frame:CGRect) {
        if let layer = self.layer.sublayers?.first(where: { it in
            it is CAGradientLayer
        }) {
            layer.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func applyHorizontalLinearGradient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    class func loadFromNib(name:String) -> UIView? {
        let nib = UINib(nibName: name, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? UIView
    }
    
    func toUIImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { ctx in
            self.layer.render(in: ctx.cgContext)
        }
    }
    
}

