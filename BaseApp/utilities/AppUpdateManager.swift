//
//  AppUpdateManager.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/01/2025.
//

import Foundation
import UIKit

class AppUpdateManager {
    // Singleton instance
    static let shared = AppUpdateManager()
    
    private init() {}
    

    
    /// Fetch version info from API
    /// - Parameter completion: Callback with latest version and force update flag
    func fetchVersionInfo(completion: @escaping (String?) -> Void) {
        ConfigurationControllerAPI.getAppVersion { data, error in
            completion(data?.version)
        }
    }
    
    /// Get the current app version
    /// - Returns: The current version as a string
    func getCurrentAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Compare app versions
    /// - Parameters:
    ///   - currentVersion: The current app version
    ///   - latestVersion: The latest app version
    /// - Returns: `true` if the current version is outdated
    func isVersionOutdated(currentVersion: String, latestVersion: String) -> Bool {
        let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }
        let latestComponents = latestVersion.split(separator: ".").compactMap { Int($0) }
        
        for (current, latest) in zip(currentComponents, latestComponents) {
            if current < latest {
                return true
            } else if current > latest {
                return false
            }
        }
        
        return currentComponents.count < latestComponents.count
    }
    
    /// Show a force update popup
    func showForceUpdatePopup() {
        DispatchQueue.main.async {
            guard let topViewController = self.getTopViewController() else { return }
            
            let alert = UIAlertController(
                title: "Update Required",
                message: "A new version of the app is available. Please update to continue.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Update Now", style: .default, handler: { _ in
                if let url = URL(string: "itms-apps://apple.com/app/id1495843717") {
                    UIApplication.shared.open(url)
                }
            }))
            
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Get the topmost view controller
    /// - Returns: The topmost view controller
    private func getTopViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return nil
        }
        return getTopViewController(from: rootViewController)
    }
    
    private func getTopViewController(from viewController: UIViewController) -> UIViewController? {
        if let presentedViewController = viewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        if let navigationController = viewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        return viewController
    }
}
