//
//  PaddedTextView.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import Foundation
import UIKit

class PaddedTextView: UITextView {
    
    var textPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = textPadding
    }
}
