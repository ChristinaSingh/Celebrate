//
//  UserDetails.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation

public class UpdateProfileResponse: Codable {
    let details: UserDetails
}

public class UserDetails: Codable {
    public let id, fullName, mobileNumber:String?
    public let phoneNumber: String?
    public let email, status, creationDate, username: String?
    public let tag: Int?
    public let avatar: avatar?
    public let birthday: String?
    public var ispublic: String?
    public let isverified:String?
    public let isallowevents:String?

    
    init(id: String?, fullName: String?, mobileNumber: String?, phoneNumber: String?, email: String?, status: String?, creationDate: String?, username: String?, tag: Int?, avatar: avatar?, birthday: String?, ispublic: String?, isverified: String?, isallowevents: String?) {
        self.id = id
        self.fullName = fullName
        self.mobileNumber = mobileNumber
        self.phoneNumber = phoneNumber
        self.email = email
        self.status = status
        self.creationDate = creationDate
        self.username = username
        self.tag = tag
        self.avatar = avatar
        self.birthday = birthday
        self.ispublic = ispublic
        self.isverified = isverified
        self.isallowevents = isallowevents

    }
}
