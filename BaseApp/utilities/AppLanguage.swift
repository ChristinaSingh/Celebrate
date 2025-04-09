//
//  L102Language.swift
//  Localization102
//
//

import UIKit

/// constants
private let APPLE_LANGUAGE_KEY = "AppleLanguages"
private let MOLHFirstTimeLanguage = "plhfirsttimelanguage"

open class AppLanguage {
    public static let shared = AppLanguage()
    
    /// get current Apple language
    public class func currentAppleLanguage() -> String {
        let current = preferredLanguage.first!
        if let hyphenIndex = current.firstIndex(of: "-") {
            return String(current[..<hyphenIndex])
        } else {
            return current
        }
    }
    /**
     Get the current language with locae e.g. ar-KW

     @return language identifier string
     */
    public class func currentLocaleIdentifier() -> String {
        let current = preferredLanguage.first!
        return current
    }
    
    /// set @lang to be the first in AppleLanguages list
    public class func setAppleLAnguageTo(_ lang: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userDefaults.synchronize()
    }
    
    /**
     Set the default language
     
     @param language string
     
     @return void
     */
    public class func setDefaultLanguage(_ language: String) {
        if !UserDefaults.standard.bool(forKey: MOLHFirstTimeLanguage) {
            AppLanguage.setAppleLAnguageTo(language)
            UserDefaults.standard.set(true, forKey: MOLHFirstTimeLanguage)
        }
    }
    
    /**
     **Check if the current language is Arabic**
     @description see if the prefix of the language is ar
     
     @return is arabic boolean
     */
    public class func isArabic() -> Bool {
        return currentAppleLanguage() == "ar"
    }
    
    /**
     **Check the current Layout direction is right to left**

     @return boolean
     */
    @available(*, deprecated, message: "Use isRTLLanguage")
    public static func isRTL() -> Bool {
        return isRTLLanguage()
    }
    
    /**
     Check if the text is english text
     
     @param text to be checked
     
     @return true of it has english text
     */
    public static func hasEnglishText(text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890poiuytrewqasdfghjklmnbvcxz")) != nil
    }
    
    /**
     Check if the current language is a right to left language
     
     @return true if its a right to left language
     */
    public static func isRTLLanguage() -> Bool {
        return !RTLLanguages.filter{$0 == currentLocaleIdentifier() || $0 == currentAppleLanguage()}.isEmpty
    }
    
    /**
     Check if the current language is a right to left language
     
     @param language to be tested

     @return true if its a right to left language
     */
    public static func isRTLLanguage(language: String) -> Bool {
        return !RTLLanguages.filter{language == $0}.isEmpty
    }
    
    private static let RTLLanguages = ["ar", "fa", "he", "ckb-IQ","ckb-IR", "ur", "ckb"]
    
    private static var preferredLanguage: [String] {
        let userDefaults = UserDefaults.standard
        let langArray = userDefaults.object(forKey: APPLE_LANGUAGE_KEY)
        return langArray as? [String] ?? []
    }
}
