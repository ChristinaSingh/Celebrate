//
//  C8Button.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/08/2024.
//

import Foundation
import UIKit
import SnapKit


class C8Button: UIButton {
    
    var isActive:Bool?{
        didSet{
            guard let isActive = isActive else {return}
            self.isUserInteractionEnabled = isActive
            if isActive {
                self.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                self.setTitleColor(.white, for: .normal)
            }else{
                self.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.15)
                self.setTitleColor(.label, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        self.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LoadingC8Button: C8Button {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var originalTitle: String?
    var loadingTintColor: UIColor?{
        didSet {
            guard let tintColor = loadingTintColor else {return}
            activityIndicator.color = tintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Add activity indicator to the button
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Center the activity indicator inside the button
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func showLoading() {
        originalTitle = title(for: .normal)
        
        setTitle("", for: .normal)
        isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        setTitle(originalTitle, for: .normal)
        isEnabled = true
    }
}
