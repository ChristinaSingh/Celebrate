//
//  SettingModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/05/2024.
//

import Foundation
import UIKit

struct SettingModel {
    let setting:Setting
    let title:String?
    let icon:UIImage?
    var notify:Bool = false
    var toggle:Bool = false
    var isButton:Bool = false
    var isOn:Bool = false
    var isLoading:Bool = false
    var isChangeLoading:Bool = false
    var address:Address? = nil
    
    init(setting: Setting, title: String? = nil, icon: UIImage? = nil, notify: Bool = false, toggle: Bool = false, isButton:Bool = false, isOn: Bool = false, isLoading:Bool = false, isChangeLoading:Bool = false, address:Address? = nil) {
        self.setting = setting
        self.title = title
        self.icon = icon
        self.notify = notify
        self.toggle = toggle
        self.isOn = isOn
        self.isButton = isButton
        self.isLoading = isLoading
        self.isChangeLoading = isChangeLoading
        self.address = address
    }
    
    
}
