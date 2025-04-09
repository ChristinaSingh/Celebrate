//
//  UsernameTextField.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/03/2024.
//

import UIKit

protocol UsernameTextFieldDelegate {
    func username(_ isValid:Bool)
}

class C8TextField: UITextField, UITextFieldDelegate {
    
    var padding:UIEdgeInsets = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        textAlignment = AppLanguage.isArabic() ? .right : .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    var isUserName:Bool = true
    var maximumCharacters:Int = 13
    var userNameDelegate: UsernameTextFieldDelegate?
    var isValidUserName:Bool?{
        didSet{
            guard let isValidUserName = isValidUserName else {return}
            if isValidUserName {
                self.addValidMark()
            }else{
                self.removeValidMark()
            }
        }
    }
    
    
    var isPassword:Bool?{
        didSet{
            guard let isPassword else {return}
            if isPassword {
                passwordBtn()
                isSecureTextEntry = true
            }else{
                removeValidMark()
            }
        }
    }
    
    var handleBackward:Bool = true
    
    override var text: String? {
        didSet {
            if text?.isEmpty ?? true {
                text = "@"
            }
        }
    }
    
    override func deleteBackward() {
        guard let text = self.text, handleBackward else {
            super.deleteBackward()
            return
        }
        if text.count == 1 && isUserName{
            return
        }
        
        super.deleteBackward()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if updatedText.count > maximumCharacters {
            return false
        }
        let disallowedCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:',.<>?/~` ")
        if let _ = string.rangeOfCharacter(from: disallowedCharacterSet) {
            return false
        }
        let englishCharacterSet = isUserName ? CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") : CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let isEnglish = string.rangeOfCharacter(from: englishCharacterSet.inverted) == nil
        userNameDelegate?.username(updatedText.count > 3)
        return isEnglish
    }
    
    
    private func addValidMark(){
        let icon = UIImageView()
        icon.image = UIImage(named: "checkmark_circle")
        icon.contentMode = .scaleAspectFit
        let iconSize = CGRect(x: 0, y: 0, width: 16, height: 16)
        icon.frame = iconSize
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize.width + 20, height: iconSize.height))
        iconContainerView.addSubview(icon)
        icon.center = iconContainerView.center
        self.rightView = iconContainerView
        self.rightViewMode = .always
    }
    
    
    
    func addBrithDayIcon(){
        let icon = UIImageView()
        icon.image = UIImage(named: "calendar")
        icon.contentMode = .scaleAspectFit
        let iconSize = CGRect(x: 0, y: 0, width: 24, height: 24)
        icon.frame = iconSize
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize.width + 20, height: iconSize.height))
        iconContainerView.addSubview(icon)
        icon.center = iconContainerView.center
        self.rightView = iconContainerView
        self.rightViewMode = .always
    }
    
    
    private func passwordBtn(){
        let btn = UIButton()
        btn.setImage(UIImage(named: "eye"), for: .normal)
        btn.setImage(UIImage(named: "eye_selected"), for: .selected)
        btn.contentMode = .scaleAspectFit
        let iconSize = CGRect(x: 0, y: 0, width: 24, height: 24)
        btn.frame = iconSize
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize.width + 20, height: iconSize.height))
        iconContainerView.addSubview(btn)
        btn.center = iconContainerView.center
        self.rightView = iconContainerView
        self.rightViewMode = .always
        btn.tap {
            btn.isSelected.toggle()
            self.isSecureTextEntry.toggle()
        }
    }
    
    
    private func removeValidMark(){
        self.rightView = nil
        self.rightViewMode = .never
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
