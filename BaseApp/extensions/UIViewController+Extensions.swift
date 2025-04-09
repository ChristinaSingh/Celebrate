//
//  UIViewController+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import Foundation
import UIKit


extension UIViewController {
    
    func reload() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view)
        if !AppLanguage.isArabic(){
            navigationController?.view.semanticContentAttribute = .forceLeftToRight
            navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        }else{
            navigationController?.view.semanticContentAttribute = .forceRightToLeft
            navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    
    func changeLanguage(){
        if !AppLanguage.isArabic(){
            AppLanguage.setAppleLAnguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.navigationController?.view.semanticContentAttribute = .forceRightToLeft
            tabBarController?.tabBar.semanticContentAttribute = .forceRightToLeft
            UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            UISlider.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            AppLanguage.setAppleLAnguageTo("en")
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.navigationController?.view.semanticContentAttribute = .forceLeftToRight
            tabBarController?.tabBar.semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UISlider.appearance().semanticContentAttribute = .forceLeftToRight
        }
        for window in UIApplication.shared.windows {
            for viewController in window.rootViewController?.children ?? [] {
                let collectionViews = viewController.view.subviews.compactMap({ $0 as? UICollectionView })
                for collectionView in collectionViews {
                    collectionView.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
                    collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
        reload()
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil, userInfo: nil)
    }
    
    var topMostViewController : UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
    
}


extension UIApplication {
    var topMostViewController : UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController
    }
}
extension Bundle {
    private static let bundleSwizzling: Void = {
        let originalSelector = #selector(getter: Bundle.main)
        let swizzledSelector = #selector(Bundle.swizzled_mainBundle)
        
        guard let originalMethod = class_getClassMethod(Bundle.self, originalSelector),
              let swizzledMethod = class_getClassMethod(Bundle.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc class func swizzled_mainBundle() -> Bundle {
        return Bundle(identifier: Bundle.currentLanguageBundle()) ?? Bundle()
    }
    
    class func swizzlePreferredLanguage() {
        _ = self.bundleSwizzling
    }
    
    class func currentLanguageBundle() -> String {
        return AppLanguage.isArabic() ? "ar.bundle" : "en.bundle"
    }
}
