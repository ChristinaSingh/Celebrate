//
//  SurpriseState.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/11/2024.
//

import Foundation


public struct SurpriseState: Codable {
    let status,answered :String?
    let lifes , fails, skips, customerstartedgame: Int?
}
