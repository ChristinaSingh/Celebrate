//
//  FadeInAnimator.swift
//  kfhonline
//
//  Created by Ehab on 07/10/2024.
//

import Foundation
import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = true
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else {
                return
            }
            let containerView = transitionContext.containerView
            toView.alpha = 0
            containerView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.alpha = 1
            }) { _ in
                transitionContext.completeTransition(true)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                return
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.alpha = 0
            }) { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
