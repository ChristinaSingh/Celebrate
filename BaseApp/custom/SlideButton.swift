//
//  SlideButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit

protocol SlideButtonDelegate: AnyObject {
    func slideButtonDidSlideComplete(_ button: SlideButton)
}

class SlideButton: UIView {

    // MARK: - Properties
    private let label = GradientLabel()
    private let thumbView = UIView()
    private let skipIcon = UIImageView(image: UIImage(named: "skips"))
    private var initialThumbCenter: CGPoint = .zero
    

    var buttonColor: UIColor = .white.withAlphaComponent(0.05) {
        didSet {
            self.backgroundColor = buttonColor
        }
    }
    
    var thumbColor: UIColor = .white {
        didSet {
            thumbView.backgroundColor = thumbColor
        }
    }
    
    var text: String = "Slide to skip this question" {
        didSet {
            label.text = text
        }
    }
    
    weak var delegate: SlideButtonDelegate?
    
    private var isSliding = false
    private let cornerRadius: CGFloat = 28.0

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - View Setup
    private func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = buttonColor
        self.clipsToBounds = true
        
        // Set up label
        label.text = text
        label.textAlignment = .center
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        self.addSubview(label)
        
        thumbView.addSubview(skipIcon)
        skipIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
       
        // Set up thumb
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = 24.0
        thumbView.isUserInteractionEnabled = true
        self.addSubview(thumbView)
        
        thumbView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(48)
        }
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Add Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        thumbView.addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialThumbCenter = thumbView.center
    }
    
    // MARK: - Gesture Handling
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let thumbView = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            isSliding = true
            
        case .changed:
            let translation = gesture.translation(in: self)
            let newCenterX = thumbView.center.x + translation.x
            
            // Limit the thumb's movement within the bounds
            if newCenterX >= initialThumbCenter.x && newCenterX <= self.bounds.width - initialThumbCenter.x {
                thumbView.center.x = newCenterX
                gesture.setTranslation(.zero, in: self)
                
                // Make label fade out as thumb slides
                let progress = (newCenterX - initialThumbCenter.x) / (self.bounds.width - initialThumbCenter.x)
                label.alpha = 1.0 - progress
            }
            
        case .ended, .cancelled:
            if thumbView.frame.maxX >= self.bounds.width - 30 {
                // Slide completed
                completeSlideAction()
            } else {
                // Reset position if not completed
                resetThumbPosition()
            }
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    private func completeSlideAction() {
        delegate?.slideButtonDidSlideComplete(self)
        UIView.animate(withDuration: 0.3) {
            self.thumbView.center.x = self.bounds.width - self.initialThumbCenter.x
        }
    }
    
    private func resetThumbPosition() {
        UIView.animate(withDuration: 0.3) {
            self.thumbView.center = self.initialThumbCenter
            self.label.alpha = 1.0
        }
    }
}
