//
//  UIApplication+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/11/2024.
//

import Foundation
import UIKit

extension UIApplication {
    
    var screen:CGRect {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate , let bounds = scene.window?.frame{
            return bounds
        }
        return .zero
    }
    
}
