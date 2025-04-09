//
//  BirthdayReminderManager.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/01/2025.
//

import Foundation
import UserNotifications

class BirthdayReminderManager {
    static let shared = BirthdayReminderManager()

    private var currentUserId: String? // Track the current user's ID

    private init() {}

    /// Set the current user ID
    /// - Parameter userId: The user ID
    func setUser(userId: String) {
        self.currentUserId = userId
    }

    /// Schedule a reminder for a friend's birthday
    func scheduleReminder(for friendName: String, month: Int, day: Int, userId: String) {
        guard currentUserId == userId else {
            print("Cannot schedule reminder: user mismatch.")
            return
        }

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else {
                print("Notification permissions not granted.")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Upcoming Birthday Reminder"
            content.body = "Don't forget to prepare for \(friendName)'s birthday tomorrow!"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.month = month
            dateComponents.day = day - 1
            if day == 1 {
                let previousMonth = month == 1 ? 12 : month - 1
                let previousMonthDays = self.daysInMonth(month: previousMonth)
                dateComponents.month = previousMonth
                dateComponents.day = previousMonthDays
            }
            dateComponents.hour = 9

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = self.reminderIdentifier(for: friendName, month: month, day: day, userId: userId)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(friendName) on \(month)/\(day).")
                }
            }
        }
    }

    /// Remove all reminders for the current user
    func clearReminders(for userId: String) {
        guard currentUserId == userId else {
            print("Cannot clear reminders: user mismatch.")
            return
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let userSpecificIdentifiers = requests
                .map { $0.identifier }
                .filter { $0.contains("BirthdayReminder_\(userId)_") }

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: userSpecificIdentifiers)
            print("All reminders cleared for user: \(userId)")
        }
    }

    /// Remove a specific reminder for a friend
    func removeReminder(for friendName: String, month: Int, day: Int, userId: String) {
        let identifier = reminderIdentifier(for: friendName, month: month, day: day, userId: userId)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification removed for \(friendName) on \(month)/\(day).")
    }

    /// Generate a unique identifier for a reminder
    private func reminderIdentifier(for friendName: String, month: Int, day: Int, userId: String) -> String {
        return "BirthdayReminder_\(userId)_\(friendName)_\(month)_\(day)"
    }

    /// Get the number of days in a given month
    private func daysInMonth(month: Int) -> Int {
        let calendar = Calendar.current
        let currentYear = Calendar.current.component(.year, from: Date())
        let dateComponents = DateComponents(year: currentYear, month: month)
        let date = calendar.date(from: dateComponents)!
        return calendar.range(of: .day, in: .month, for: date)!.count
    }
}
