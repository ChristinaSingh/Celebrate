//
//  C8Label+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import Foundation
import UIKit

extension UILabel {
    
    
    func addStroke(_ labelText : String) {
        guard let font = font else { return }
        let color = self.textColor ?? .black
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.strikethroughColor, value: color, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    
    class func createMandatoryLabel(withText text: String, font: UIFont?, textColor: UIColor, asteriskColor: UIColor) -> C8Label {
        let label = C8Label()
        let mainText = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: textColor,
            .font: font ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        ])
        let asterisk = NSAttributedString(string: " *", attributes: [
            .foregroundColor: asteriskColor,
            .font: font ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        ])
        mainText.append(asterisk)
        label.attributedText = mainText
        return label
    }
    
    
    class func createAttributedText(withText text: String, font: UIFont?, textColor: UIColor, asteriskColor: UIColor) -> NSMutableAttributedString {
        let mainText = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: textColor,
            .font: font ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        ])
        let asterisk = NSAttributedString(string: " *", attributes: [
            .foregroundColor: asteriskColor,
            .font: font ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        ])
        mainText.append(asterisk)
        return mainText
    }
    
    func setColorForSubstring(substring: String, color: UIColor) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: substring)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        self.attributedText = attributedString
    }
    
    
    func setLineHeight(lineHeight: CGFloat) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - (self.font?.lineHeight ?? 0)

        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    
    func underline() {
        guard let text = self.text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedString
    }
    
    func underlineWithColor(color: UIColor) {
        guard let text = self.text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedString
    }
    
}

