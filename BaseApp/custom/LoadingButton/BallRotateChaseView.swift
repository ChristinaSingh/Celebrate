//
//  BallRotateChaseView.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/04/2024.
//

import Foundation
import UIKit

class BallRotateChaseView: UIView {
    
    private let ballContainerLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    private let ballSize: CGFloat = 8.0
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
        let animation = NVActivityIndicatorAnimationBallRotateChase()
        animation.setUpAnimation(in: ballContainerLayer, size:  CGSize(width: ballSize * 3 + ballSpacing * 2, height: ballSize), color: color)
    }
}
