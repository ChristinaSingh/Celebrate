//
//  InputsValidator.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import Foundation
class InputsValidator: NSObject {

    class func isValidMobileNumber(_ number: String) -> Bool {
        do {
            let regx:String = #"^[4-6|9]\d*$"#
            let regex = try NSRegularExpression(pattern: regx)
            let matches = regex.matches(in: number, range: NSRange(location: 0, length: number.utf16.count))
            return !matches.isEmpty
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
}
