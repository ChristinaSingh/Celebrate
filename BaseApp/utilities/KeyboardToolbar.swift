//
//  KeyboardToolbar.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/12/2024.
//

import Foundation
import UIKit

class KeyboardToolbar: UIToolbar {
    static let shared:KeyboardToolbar = KeyboardToolbar()
    // MARK: - Properties
    private weak var activeField: UIResponder?
    private var fields: [UIResponder]
    private weak var parentView: UIView?
    
    init () {
        self.fields = []
        super.init(frame: .zero)
    }
    
    // MARK: - Initialization
    func setup(fields: [UIResponder], parentView: UIView) {
        self.fields = fields
        self.parentView = parentView
        setupToolbar()
        self.attachToFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Toolbar Setup
    private func setupToolbar() {
        sizeToFit()
        
        // Create buttons with images
        let previousButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.up"), // Use SF Symbols or your custom image
            style: .plain,
            target: self,
            action: #selector(goToPreviousField)
        )
        
        let nextButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"), // Use SF Symbols or your custom image
            style: .plain,
            target: self,
            action: #selector(goToNextField)
        )
        
        let doneButton = UIBarButtonItem(
            title: "Done".localized,
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Add buttons to the toolbar
        setItems([previousButton, nextButton, spacer ,doneButton], animated: false)
    }
    
    // MARK: - Button Actions
    @objc private func goToPreviousField() {
        guard let activeField = activeField,
              let index = fields.firstIndex(of: activeField),
              index > 0 else { return }
        
        fields[safe: index - 1]?.becomeFirstResponder()
        updateActiveField(fields[safe: index - 1])
    }
    
    @objc private func goToNextField() {
        guard let activeField = activeField,
              let index = fields.firstIndex(of: activeField),
              index < fields.count - 1 else { return }
        
        fields[safe: index + 1]?.becomeFirstResponder()
        updateActiveField(fields[safe: index + 1])
    }
    
    @objc private func dismissKeyboard() {
        parentView?.endEditing(true)
    }
    
    // MARK: - Attach Toolbar to Fields
    func attachToFields() {
        for field in fields {
            if let textField = field as? UITextField {
                textField.inputAccessoryView = self
            } else if let textView = field as? UITextView {
                textView.inputAccessoryView = self
            }
        }
    }
    
    // MARK: - Update Active Field
    func updateActiveField(_ activeField: UIResponder?) {
        self.activeField = activeField
        scrollToField(activeField)
    }
    
    // MARK: - Scroll to Field
    private func scrollToField(_ field: UIResponder?) {
        guard let field = field as? UIView,
              let scrollView = findScrollView(in: parentView) else { return }
        
        // Convert field frame to scrollView coordinate space
        let fieldFrame = field.convert(field.bounds, to: scrollView)
        
        // Adjust contentOffset to make field visible
        scrollView.scrollRectToVisible(fieldFrame, animated: true)
    }
    
    private func findScrollView(in view: UIView?) -> UIScrollView? {
        var currentView = view
        while currentView != nil {
            if let scrollView = currentView as? UIScrollView {
                return scrollView
            }
            currentView = currentView?.superview
        }
        return nil
    }
}
