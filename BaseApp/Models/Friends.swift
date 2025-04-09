//
//  Friends.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import Foundation
public struct Friend: Codable {
    let fid, custid, friendCustid :String?
    var invStatus: String?
    let createddate, accepteddate: String?
    let rejecteddate: String?
    var remindme:Int?
    let addressId:String?
    let locationId:String?
    var invitestatus: Int? = nil
    var customer: FriendCustomer?
    var loading:Bool = false

    enum CodingKeys: String, CodingKey {
        case fid, custid
        case friendCustid = "friend_custid"
        case invStatus = "inv_status"
        case addressId = "addressid"
        case locationId
        case createddate, accepteddate, rejecteddate, customer, remindme
    }
    
    init(fid: String?, custid: String?, friendCustid: String?, invStatus: String?, createddate: String?, accepteddate: String?, rejecteddate: String?, remindme: Int?,invitestatus: Int? = nil,  customer: FriendCustomer? = nil, addressId:String? = nil, locationId:String? = nil) {
        self.fid = fid
        self.custid = custid
        self.friendCustid = friendCustid
        self.invStatus = invStatus
        self.createddate = createddate
        self.accepteddate = accepteddate
        self.rejecteddate = rejecteddate
        self.remindme = remindme
        self.customer = customer
        self.invitestatus = invitestatus
        self.addressId = addressId
        self.locationId = locationId
    }
}

// MARK: - Customer
public struct FriendCustomer: Codable {
    let fullname, username: String?
    var avatar: FriendAvatar?
    let birthday: String?
    let isverified:String?
    
    func formateDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "ddMM"
        if let userBirthDay = birthday{
            if let birthDate = dateFormatter.date(from: userBirthDay) {
                dateFormatter.dateFormat = "dd MMM"
                return dateFormatter.string(from: birthDate)
            }
        }
        return ""
    }
    
    func formateDate() -> (month: Int, day: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMM" // Assuming the input format is "ddMM"
        
        if let userBirthDay = birthday, // `birthday` is a string in "ddMM" format
           let birthDate = dateFormatter.date(from: userBirthDay) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: birthDate)
            let month = calendar.component(.month, from: birthDate)
            return (month, day)
        }
        return nil // Return nil if the date could not be parsed
    }
}

// MARK: - Avatar
public struct FriendAvatar: Codable {
    let id, name: String?
    let imageURL: String?
    let status, createdAt, updatedAt: String?
    let deletedAt: String?
    let sortorder: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case sortorder
    }
}

public typealias Friends = [Friend]
