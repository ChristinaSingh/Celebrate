//
//  PlaceholderTextView.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/12/2024.
//

import Foundation
import UIKit

class PlaceholderTextView: UITextView {

    // MARK: - Properties
    
    /// Placeholder text label
    private let placeholderLabel = UILabel()

    /// Placeholder text
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    /// Placeholder color
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    /// Placeholder font
    var placeholderFont: UIFont? {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configurePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurePlaceholder()
    }
    
    // MARK: - Setup Placeholder
    private func configurePlaceholder() {
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = self.font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add placeholder label to the textView
        addSubview(placeholderLabel)
        
        // Constraints for placeholder
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        // Observers for text changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Placeholder Visibility Management
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
