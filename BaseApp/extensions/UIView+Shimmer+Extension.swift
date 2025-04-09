//
//  UIView+Shimmer+Extension.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var _cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
//    @IBInspectable
//    var isShimmering: Bool {
//        get {
//            return shimmerLayer != nil
//        }
//        set {
//            if newValue {
//                startShimmering()
//            } else {
//                stopShimmering()
//            }
//        }
//    }
    
    private var shimmerLayer: CAGradientLayer? {
        return layer.sublayers?.first(where: { $0.name == "shimmerLayer" }) as? CAGradientLayer
    }
    
    private func startShimmering() {
        guard shimmerLayer == nil else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "shimmerLayer"
        gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: 3*bounds.width, height: bounds.height)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2.0
        animation.fromValue = -bounds.width
        animation.toValue = 2*bounds.width
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    private func stopShimmering() {
        shimmerLayer?.removeFromSuperlayer()
    }
}
