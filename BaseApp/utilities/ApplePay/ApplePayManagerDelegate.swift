//
//  ApplePayManagerDelegate.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
protocol ApplePayManagerDelegate {
    func didFinishApplePay(_ response: String)
    func didFailApplePay(_ error: String)
}
