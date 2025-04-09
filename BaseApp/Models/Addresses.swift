//
//  Addresses.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import Foundation
public struct Addresses: Codable {
    let addresses: [Address]?
}

// MARK: - Address
public struct Address: Codable {
    var id: String?
    var type: AddressType?
    var location: Location?
    var name, area, block, street: String?
    var building:String?
    var floor, suitNo, addtionalDirection: String?
    var alternateNumber: String?
    var additionalinfo , coordinates, imagedata: String?
    var createdOn: String?
    var isshared:String?
    var isSelected:Bool = false
    var loading:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id , type , location , name, area, block, street
        case building, floor, suitNo, addtionalDirection, alternateNumber
        case additionalinfo , coordinates, imagedata, createdOn , isshared
    }
    
    
    init(id: String? = nil, type: AddressType? = nil, location: Location? = nil, name: String? = nil, area: String? = nil, block: String? = nil, street: String? = nil, building: String? = nil, floor: String? = nil, suitNo: String? = nil, addtionalDirection: String? = nil, alternateNumber: String? = nil, additionalinfo: String? = nil, coordinates: String? = nil, imagedata: String? = nil, createdOn: String? = nil, isshared: String? = nil, isSelected: Bool, loading: Bool) {
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
        self.imagedata = imagedata
        self.createdOn = createdOn
        self.isshared = isshared
        self.isSelected = isSelected
        self.loading = loading
    }
    
    func isValid() -> Bool {
        if name?.isBlank == false && type?.rawValue.isBlank == false && block?.isBlank == false && street?.isBlank == false && building?.isBlank == false && alternateNumber?.isBlank == false && alternateNumber?.count == 8 {
            return true
        }
        return false
    }
}

// MARK: - Location
public struct Location: Codable {
    let locationID, locationName: String?
    let governateName: String?
    let arGovernateName: String?
    let arLocationName: String?
    
    enum CodingKeys: String, CodingKey {
        case locationID , locationName , governateName
        case arGovernateName = "ar_governateName"
        case arLocationName = "ar_locationName"
    }
}

