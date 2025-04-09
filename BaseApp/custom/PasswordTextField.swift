//
//  PasswordTextField.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit


protocol PasswordTextFieldDelegate {
    func password(_ isValid:Bool)
}

class PasswordTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
       // self.isSecureTextEntry = true
    }
    
    var minimumCharacters:Int = 8
    var passwordDelegate: PasswordTextFieldDelegate?
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        if currentText.count >= 15 {
            return false
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let englishCharacterSet = CharacterSet(charactersIn: "_&*!@#$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let isEnglish = string.rangeOfCharacter(from: englishCharacterSet.inverted) == nil
        passwordDelegate?.password(updatedText.count >= minimumCharacters)
        return isEnglish
    }
}
