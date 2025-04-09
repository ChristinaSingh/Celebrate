//
//  BirthDateNotificationCenter.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import Foundation
import UserNotifications

class BirthDateNotificationCenter {
    
    static let shared = BirthDateNotificationCenter()
    
    private init() {}
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted)
        }
    }
    
    func scheduleBirthdayNotification(for friend: Friend, birthdate: String) {
        guard let dateComponents = dateComponents(from: birthdate) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Birthday Reminder"
        content.body = "It's \(friend.customer?.fullname ?? "")'s birthday today!"
        content.sound = .default
        
        var triggerDateComponents = dateComponents
        triggerDateComponents.hour = 0
        triggerDateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
        self.cancelBirthdayNotification(for: friend)
        let identifier = "\(friend.fid ?? "")-\(friend.customer?.fullname ?? "")-birthday"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelBirthdayNotification(for friend: Friend) {
        let identifier = "\(friend.fid ?? "")-\(friend.customer?.fullname ?? "")-birthday"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    
    private func dateComponents(from ddMMString: String) -> DateComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMM"
        
        guard let date = dateFormatter.date(from: ddMMString) else { return nil }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        
        return dateComponents
    }
}
