//
//  LinearProgressBar.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit

class LinearProgressBar: UIView {
    
    // MARK: - Properties
    private let progressLayer = CALayer()
    private var progress: CGFloat = 0.0 {
        didSet {
            updateProgressLayer()
        }
    }
    
    var barColor: UIColor = .blue {
        didSet {
            progressLayer.backgroundColor = barColor.cgColor
        }
    }
    
    var trackColor: UIColor = .lightGray {
        didSet {
            self.backgroundColor = trackColor
        }
    }
    
    var barHeight: CGFloat = 4.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    var cornerRadius: CGFloat = 4.0 {
        didSet {
            progressLayer.cornerRadius = cornerRadius
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = trackColor
        progressLayer.backgroundColor = barColor.cgColor
        self.layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateProgressLayer()
    }
    
    // MARK: - Methods
    func setProgress(_ value: CGFloat, animated: Bool = true, duration: TimeInterval = 0.25) {
        // Ensure value is within bounds
        let clampedValue = max(0.0, min(1.0, value))
        self.progress = clampedValue
        
        if animated {
            let animation = CABasicAnimation(keyPath: "bounds.size.width")
            animation.fromValue = progressLayer.bounds.width
            animation.toValue = clampedValue * self.bounds.width
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progressAnimation")
        }
    }
    
    private func updateProgressLayer() {
        progressLayer.frame = CGRect(x: 0, y: (self.bounds.height - barHeight) / 2, width: progress * self.bounds.width, height: barHeight)
    }
}
