//
//  AppDelegate.swift
//  BaseApp
//
//  Created by Ehab on 13/03/2024.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppLanguage.setDefaultLanguage("en")
        ApplePayManager.shared.setupApplePay()
//        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.toolbarConfiguration.useTextFieldTintColor = true
        IQKeyboardManager.shared.disabledToolbarClasses = [AddAddressViewController.self]
        NetworkActivityLogger.shared.startLogging()
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        setupReminders()
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: Any) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func getToken(){
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
              UserDefaults.standard.setValue(token, forKey: "playerId")
          }
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        C8NotificationCenter.requestAuthorization { isGranted, _ in
            if isGranted {
                self.getToken()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        registerForPushNotifications()
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("didReceiveRegistrationToken: \(fcmToken ?? "")")
        if let token = fcmToken {
          print("FCM registration token: \(token)")
            UserDefaults.standard.setValue(token, forKey: "playerId")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func setupReminders(){
        if let user = User.load(), let userId =  user.details?.id {
            BirthdayReminderManager.shared.setUser(userId: userId)
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let existingReminders = requests.filter { $0.identifier.contains("BirthdayReminder_\(userId)_") }
                if existingReminders.isEmpty {
                    FriendsControllerAPI.friends() { data, error in
                        if let friends = data {
                            friends.forEach { friend in
                                if let name = friend.customer?.fullname, let month = friend.customer?.formateDate()?.month, let day = friend.customer?.formateDate()?.day, friend.remindme == 1 {
                                    BirthdayReminderManager.shared.scheduleReminder(for: name, month: month, day: day, userId: userId)
                                }
                            }
                        }
                    }
                } else {
                    print("Reminders are already set for user: \(userId)")
                }
            }
            
        }
        
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BaseApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

