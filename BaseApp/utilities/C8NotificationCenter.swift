//
//  NotificationCenter.swift
//  BaseApp
//
//  Created by Ihab yasser on 05/04/2024.
//

import Foundation
import UserNotifications


class C8NotificationCenter {
    
    private let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    private var notificationActions: [UNNotificationAction] = []
    private var notificationContent = UNMutableNotificationContent()
    
    
    func setCategory() -> C8NotificationCenter {
        let notificationCategory = UNNotificationCategory(
            identifier: "C8NotificationsCategory",
            actions: notificationActions,
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )
        notificationCenter.setNotificationCategories(
           [notificationCategory]
        )
        return self
    }
    
    
    func setContent() -> C8NotificationCenter {
        notificationContent.title = "Your Nasa Daily Photo"
        notificationContent.body = "Long press to see you daily nasa photo"
        notificationContent.sound = UNNotificationSound.default
        notificationContent.categoryIdentifier = "NasaDailyPhoto"
        return self
    }
    
    func build() {
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "C8NotificationsCategory",
            content: notificationContent,
            trigger: trigger
        )
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    static func requestAuthorization(completion: @escaping (Bool , C8NotificationCenter) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            completion(granted, C8NotificationCenter())
        }
    }

}



   
   
  
   
   
