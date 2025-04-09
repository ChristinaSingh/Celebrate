//
//  PendingApprovalRequest.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/09/2024.
//

import Foundation
public struct PendingApprovalRequest: Codable {
    let cartItemID: [String]?
    let pendingOrderApprovalStatus: Int?

    enum CodingKeys: String, CodingKey {
        case cartItemID = "cart_item_id"
        case pendingOrderApprovalStatus = "pending_order_approval_status"
    }
}
