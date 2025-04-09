//
//  KeyboardHandling.swift
//  BaseApp
//
//  Created by Ihab yasser on 20/05/2024.
//

import Foundation
import UIKit
import SnapKit

class KeyboardManager {

    private weak var viewController: UIViewController?
    private var bottomConstraint: Constraint?

    init(viewController: UIViewController, bottomConstraint: Constraint?) {
        self.viewController = viewController
        self.bottomConstraint = bottomConstraint
        addKeyboardObservers()
    }

    deinit {
        removeKeyboardObservers()
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let viewController = viewController,
           let bottomConstraint = bottomConstraint {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                bottomConstraint.update(offset: -keyboardHeight)
                viewController.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        if let viewController = viewController,
           let bottomConstraint = bottomConstraint {
            UIView.animate(withDuration: 0.3) {
                bottomConstraint.update(offset: 0)
                viewController.view.layoutIfNeeded()
            }
        }
    }
}
