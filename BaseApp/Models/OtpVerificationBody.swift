//
//  OtpVerificationBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/08/2024.
//

import Foundation
public struct OtpVerificationBody: Codable {
    let mobile, channel, action, otp: String?
    
    init(mobile: String? = nil, channel: String? = nil, action: String? = nil, otp: String? = nil) {
        self.mobile = mobile
        self.channel = channel
        self.action = action
        self.otp = otp
    }
}
