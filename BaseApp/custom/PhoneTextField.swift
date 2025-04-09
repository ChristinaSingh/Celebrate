//
//  PhoneTextField.swift
//  BaseApp
//
//  Created by Ehab on 14/03/2024.
//

import Foundation
import UIKit

class PhoneTextField: UIView {
    
    private let textfield:UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.borderStyle = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    
    private let flagImg:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "kw")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    var flag:UIImage? = UIImage(named: "kw"){
        didSet{
            flagImg.image = flag
        }
    }
    
    var font:UIFont = UIFont.systemFont(ofSize: 16, weight: .regular){
        didSet{
            textfield.font = font
        }
    }
    
    
    var placeholder:String = "Phone number"{
        didSet{
            textfield.placeholder = placeholder
        }
    }
    
    var placeholderColor:UIColor = .lightGray {
        didSet{
            textfield.attributedPlaceholder = NSAttributedString(
                string: placeholder, // becareful to change placeholder color set placeholder before setting color
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
    }
    
    
    var textColor:UIColor = .black {
        didSet{
            textfield.textColor = textColor
        }
    }
    
    var regx:String = #"^[4-6|9]\d{7,}$"#
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup(){
        [flagImg , textfield].forEach { view in
            self.addSubview(view)
        }
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        flagImg.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 10).isActive = true
        flagImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        flagImg.widthAnchor.constraint(equalToConstant: 24).isActive = true
        flagImg.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        
        textfield.leadingAnchor.constraint(equalTo: self.flagImg.trailingAnchor, constant: 8).isActive = true
        textfield.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        textfield.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        textfield.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        textfield.delegate = self
    }
    
   
    
}

extension PhoneTextField:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            self.layer.borderColor = updatedText.isEmpty ? UIColor.lightGray.cgColor : ((isValidMobileNumber(updatedText) && updatedText.count >= 8) ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor)
            return updatedText.count <= 8
        }
        return true
    }
    
    private func isValidMobileNumber(_ number: String) -> Bool {
        let regex = regx
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let matches = regex.matches(in: number, range: NSRange(location: 0, length: number.utf16.count))
            return !matches.isEmpty
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
}
