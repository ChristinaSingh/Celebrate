//
//  UIButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
import UIKit

extension UIButton {
    
    func tap(callback: @escaping () -> Void) {
        self.endEditing(true)
        addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        if let hashValue = UnsafeRawPointer(bitPattern: "callback".hashValue) {
            objc_setAssociatedObject(self, hashValue, callback, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    @objc private func buttonTapped(sender: UIButton) {
        if let hashValue = UnsafeRawPointer(bitPattern: "callback".hashValue) {
            if let callback = objc_getAssociatedObject(self, hashValue) as? () -> Void {
                callback()
            }
        }
    }
}
