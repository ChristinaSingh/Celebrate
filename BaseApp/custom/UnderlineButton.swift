//
//  UnderlineButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/11/2024.
//

import Foundation
import UIKit

class UnderlineButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Apply underline attribute to the button title
        guard let title = self.title(for: .normal) else { return }
        let attributedString = NSAttributedString(string: title, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: self.titleColor(for: .normal) ?? UIColor.black
        ])
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setUnderlineTitle(_ title: String, for state: UIControl.State) {
        let attributedString = NSAttributedString(string: title, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: self.titleColor(for: state) ?? UIColor.black
        ])
        self.setAttributedTitle(attributedString, for: state)
    }
}
