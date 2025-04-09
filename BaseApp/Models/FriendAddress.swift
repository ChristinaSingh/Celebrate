//
//  FriendAddress.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/01/2025.
//

import Foundation
public struct FriendAddress: Codable {
    
    let addresses: [FriendProfileAddress]?
    
    init(addresses: [FriendProfileAddress]?) {
        self.addresses = addresses
    }
}
public struct FriendProfileAddress: Codable {
    
    let id, type: String?
    let location: FriendLocation?
    let name, area, block, street: String?
    let building: String?
    let floor, suitNo, addtionalDirection, alternateNumber: String?
    let additionalinfo, coordinates: String?
    let createdOn: String?
    let isshared: String?
    
    init(id: String?, type: String?, location: FriendLocation?, name: String?, area: String?, block: String?, street: String?, building: String?, floor: String?, suitNo: String?, addtionalDirection: String?, alternateNumber: String?, additionalinfo: String?, coordinates: String?, createdOn: String?, isshared: String?) {
        self.id = id
        self.type = type
        self.location = location
        self.name = name
        self.area = area
        self.block = block
        self.street = street
        self.building = building
        self.floor = floor
        self.suitNo = suitNo
        self.addtionalDirection = addtionalDirection
        self.alternateNumber = alternateNumber
        self.additionalinfo = additionalinfo
        self.coordinates = coordinates
        self.createdOn = createdOn
        self.isshared = isshared
    }
}
public struct FriendLocation: Codable {
    
    let locationID, locationName, governateName: String?
    
    init(locationID: String?, locationName: String?, governateName: String?) {
        self.locationID = locationID
        self.locationName = locationName
        self.governateName = governateName
    }
}
