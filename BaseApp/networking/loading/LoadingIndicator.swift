//
//  LoadingIndicator.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
import UIKit
import SnapKit

class LoadingIndicator : NSObject {
    
    static let shared = LoadingIndicator()
    
    private var containerView: UIView?
    private var overlayView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    
    private func show() {
        guard containerView == nil else { return }
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first {
            overlayView = UIView(frame: window.bounds)
            overlayView?.backgroundColor = UIColor.label.withAlphaComponent(0.1)
            containerView = UIView()
            containerView?.backgroundColor = UIColor.systemBackground
            containerView?.layer.cornerRadius = 8
            containerView?.layer.masksToBounds = true
            
            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator?.tintColor = .accent
            activityIndicator?.startAnimating()
            
            if let containerView = containerView, let activityIndicator = activityIndicator , let overlayView = overlayView {
                window.addSubview(overlayView)
                overlayView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                overlayView.addSubview(containerView)
                containerView.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                    make.width.height.equalTo(60)
                }
                
                containerView.addSubview(activityIndicator)
                activityIndicator.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
            }
        }
    }
    
    private func hide() {
        overlayView?.removeFromSuperview()
        activityIndicator?.removeFromSuperview()
        containerView?.removeFromSuperview()
        activityIndicator = nil
        containerView = nil
        overlayView = nil
    }
    
    func loading(isShow:Bool){
        if isShow {
            show()
        }else{
            hide()
        }
    }
}
