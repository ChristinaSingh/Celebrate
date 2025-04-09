//
//  CircleStrokeSpinView.swift
//  BaseApp
//
//  Created by Ihab yasser on 16/05/2024.
//

import Foundation
import UIKit


class CircleStrokeSpinView: UIView {
    
    private let ballContainerLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    let ballSize: CGFloat = 8.0
    private let ballSpacing: CGFloat = 4.0
    var color:UIColor = .black
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBallContainerLayer()
        startAnimation()
    }
    
    private func setupBallContainerLayer() {
        ballContainerLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        layer.addSublayer(ballContainerLayer)
    }
    
    
    private func startAnimation() {
        let animation = NVActivityIndicatorAnimationCircleStrokeSpin()
        animation.setUpAnimation(in: ballContainerLayer, size:  frame.size, color: color)
    }
}
