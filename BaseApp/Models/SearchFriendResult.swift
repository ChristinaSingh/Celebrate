//
//  SearchFriendResult.swift
//  BaseApp
//
//  Created by Ihab yasser on 16/05/2024.
//

import Foundation
public struct SearchFriendResult: Codable {
    let details: [SearchResult]?
    
    func toFriends() -> Friends {
        return details?.map { result in
            Friend(fid: result.id, custid: nil, friendCustid: nil, invStatus: nil, createddate: nil, accepteddate: nil, rejecteddate: nil, remindme: nil, invitestatus: result.invitestatus, customer: FriendCustomer(fullname: result.fullName, username: result.username, birthday: result.birthday, isverified: result.isverified))
        } ?? []
    }
}

// MARK: - Detail
public struct SearchResult: Codable {
    let id, fullName: String?
    let mobileNumber, phoneNumber: String?
    let email, status, creationDate, username: String?
    let tag: Int?
    let avatar: FriendAvatar?
    let birthday: String?
    let invitestatus: Int?
    let isverified:String?
    let ispublic:String?
    enum CodingKeys: String, CodingKey {
        case id, fullName
        case mobileNumber, phoneNumber
        case email, status, creationDate, username
        case tag
        case avatar , invitestatus
        case birthday , ispublic , isverified
    }
}
