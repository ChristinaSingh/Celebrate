//
//  DateFormatter.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation

extension DateFormatter {
    
    class var standard: DateFormatter {
        let formatter = DateFormatter()
        // example 2018-11-14T10:11:14.000Z
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en-US")
        if let timeZone = TimeZone.init(identifier: "Asia/Kuwait") {
            formatter.timeZone = timeZone
        }
        return formatter
    }
    
    
    class var title: DateFormatter {
        let formatter = DateFormatter()
        // example 2018-11-14T10:11:14.000Z
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en-US")
        if let timeZone = TimeZone.init(identifier: "Asia/Kuwait") {
            formatter.timeZone = timeZone
        }
        return formatter
    }
    
    class var UTC: DateFormatter {
        let formatter = DateFormatter()
        // example 2018-11-14T10:11:14.000Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en-US")
        if let timeZone = TimeZone.init(identifier: "UTC") {
            formatter.timeZone = timeZone
        }
        return formatter
    }
    
    class var onlyTime: DateFormatter {
        let formatter = DateFormatter()
        // example 2018-11-14T10:11:14.000Z
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en-US")
        if let timeZone = TimeZone.init(identifier: "Asia/Kuwait") {
            formatter.timeZone = timeZone
        }
        return formatter
    }
    
    class func differnceBetweenDates (first: Date, last: Date) -> Int {
        let seconds = Int(first.timeIntervalSinceReferenceDate - last.timeIntervalSinceReferenceDate)
        return Int((seconds % 31536000) / 86400)
    }
    
   class func formateTime(time:String)->String{
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"
        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"
        outFormatter.amSymbol = "AM"
        outFormatter.pmSymbol = "PM"
        let date = inFormatter.date(from: time)!
       return outFormatter.string(from: date)
    }
    
    class func formateDate(date:String) -> String{
        return DateFormatter.standard.string(from: DateFormatter.standard.date(from: date) ?? Date())
    }
    
    
    class func formateDate(date:String, formate:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: DateFormatter.standard.date(from: date) ?? Date())
    }
    
    class func formateDate(date:Date, formate:String) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
}
extension Date {
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }

    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
}
