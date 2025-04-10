//
//  OcassionDate.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import Foundation
class OcassionDate: NSObject {
    
    static let shared:OcassionDate = OcassionDate()
    
    
    func save(date:String){
        UserDefaults.standard.setValue(date, forKey: "date")
    }
    
    func saveTime(time:String){
        UserDefaults.standard.setValue(time, forKey: "time")
    }
    
    func getDate() -> String? {
        return UserDefaults.standard.string(forKey: "date")
    }
    
    func getTime() -> String? {
        return UserDefaults.standard.string(forKey: "time")
    }
    
    func removeDate(){
        UserDefaults.standard.removeObject(forKey: "date")
        UserDefaults.standard.removeObject(forKey: "time")
    }
    
    
    func getEventDate() -> Date? {
        if let date = getDate() {
            let formatter = DateFormatter.standard
            return formatter.date(from: date)
        }
        return nil
    }
    func getEventTime() -> Date? {
        if let date = getTime() {
            let formatter = DateFormatter.onlyTime
            return formatter.date(from: date)
        }
        return nil
    }

    
}
