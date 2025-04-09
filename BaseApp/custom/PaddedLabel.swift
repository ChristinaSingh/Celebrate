//
//  PaddedLabel.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import UIKit

class PaddedLabel: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
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
}
