//
//  C8Label.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/09/2024.
//

import Foundation
import UIKit

class C8Label: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    
    override var text: String?{
        didSet{
            applyTextAttributes()
        }
    }
    
    override var font: UIFont?{
        didSet{
            applyTextAttributes()
        }
    }
    
    
    override var textColor: UIColor?{
        didSet{
            applyTextAttributes()
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.width += textInsets.left + textInsets.right
        sizeThatFits.height += textInsets.top + textInsets.bottom
        return sizeThatFits
    }
    
    private func applyTextAttributes() {
        if !AppLanguage.isArabic() {return}
        guard let currentText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -5
        paragraphStyle.lineHeightMultiple = 0.85
        paragraphStyle.alignment = self.textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: self.font ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: self.textColor ?? .label,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: -2
        ]
        let attributedString = NSAttributedString(string: currentText, attributes: attributes)
        super.attributedText = attributedString
    }
}

