//
//  Int+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation


extension Int {

    func formatSecondsToTimerString() -> String {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
