//
//  UserNameExcludedNamesManager.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/03/2024.
//

import Foundation
import UIKit

class ExcludedUserNamesManager: NSObject {
    
    static let shared = ExcludedUserNamesManager()
    private var badWords: Set<String> = []
    private let badWordsFileName = ""
    
    private func loadExcludedUserNames(){
        if let badWordsFileURL = Bundle.main.url(forResource: "ExcludedUserNames", withExtension: "json") {
            do {
                let data = try Data(contentsOf: badWordsFileURL)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonObject = json as? [String: Any], let badWordsArray = jsonObject["UserNames"] as? [String] {
                    badWords = Set(badWordsArray)
                }
            } catch {
                print("Error loading bad words: \(error)")
            }
        } else {
            print("Bad words JSON file not found.")
        }
    }
    
    
    func isUserNameAcceptted(username:String) -> Bool{
        loadExcludedUserNames()
        for word in badWords {
            if username.localizedCaseInsensitiveContains(word) {
                return false
            }
        }
        return true
    }
    
}
