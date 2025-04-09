//
//  C8InputView.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import UIKit
import SnapKit


protocol InputValidationDelegate {
    func isValidPhone( _ isValid: Bool)
    func isValidEmail( _ isValid: Bool)
}

extension InputValidationDelegate{
    func isValidPhone( _ isValid: Bool){}
    func isValidEmail( _ isValid: Bool){}
}

class C8InputView: UIView {
    
    let textfield:UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        textfield.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        textfield.textAlignment = AppLanguage.isArabic() ? .right : .left
        return textfield
    }()
    
    private let countryCodeLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "🇰🇼 +965"
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        return lbl
    }()
    
    var delegate:InputValidationDelegate?
    var isPhone:Bool?{
        didSet{
            guard let isPhone = isPhone else {return}
            if isPhone {
                self.textfield.delegate = self
                self.addSubview(countryCodeLbl)
                self.textfield.keyboardType = .asciiCapableNumberPad
                countryCodeLbl.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(16)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(68)
                }
                self.textfield.snp.remakeConstraints { make in
                    make.leading.equalTo(self.countryCodeLbl.snp.trailing).offset(8)
                    make.trailing.equalToSuperview().offset(-16)
                    make.top.bottom.equalToSuperview()
                }
            }
        }
    }
    
    
    var isEmail:Bool?{
        didSet{
            guard let isEmail = isEmail else {return}
            if isEmail {
                self.textfield.delegate = self
                self.textfield.keyboardType = .emailAddress
            }
        }
    }

    var text:String?{
        set{
            self.textfield.text = newValue
        }
        
        get{
            return textfield.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textfield)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        self.clipsToBounds = true
        textfield.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension C8InputView:UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let isPhone = isPhone, isPhone {
            return isValidMobile(range: range, text: textField.text, string: string)
        }else if let isEmail = isEmail, isEmail{
            self.delegate?.isValidEmail(isValidEmail(range: range, text: textField.text, string: string))
            return true
        }
        return false
    }
    
    
    private func isValidMobile(range: NSRange , text:String?, string: String) -> Bool{
        if let text = text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty {
                return true
            }else if updatedText.count < 8{
                delegate?.isValidPhone(false)
            }else{
                delegate?.isValidPhone(true)
            }
            return InputsValidator.isValidMobileNumber(updatedText) && updatedText.count <= 8
        }
        return false
    }
    
    
    private func isValidEmail(range: NSRange , text:String?, string: String) -> Bool{
        let currentText = text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return InputsValidator.isValidEmail(updatedText)
    }
    
}
