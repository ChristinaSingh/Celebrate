//
//  AddressBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import Foundation

public struct AddressBody:Codable {
    var type , name , area , street , building , floor , suitNo , addtionalDirection , alternateNumber , block , locationID , additionalinfo , coordinates , imagedata , isgift: String?
    
    
    public init(type: String? = nil, name: String? = nil, area: String? = nil, street: String? = nil, building: String? = nil, floor: String? = nil, suitNo: String? = nil, addtionalDirection: String? = nil, alternateNumber: String? = nil, block: String? = nil, locationID: String? = nil, additionalinfo: String? = nil, coordinates: String? = nil, imagedata: String? = nil, isgift: String? = nil) {
        self.type = type
        self.name = name
        self.area = area
        self.street = street
        self.building = building
        self.floor = floor
        self.suitNo = suitNo
        self.addtionalDirection = addtionalDirection
        self.alternateNumber = alternateNumber
        self.block = block
        self.locationID = locationID
        self.additionalinfo = additionalinfo
        self.coordinates = coordinates
        self.imagedata = imagedata
        self.isgift = isgift
    }
    
    
    func isValid() -> Bool {
        if type?.lowercased() == "H".lowercased(){
            if name?.isBlank == false && locationID?.isBlank == false && type?.isBlank == false && block?.isBlank == false && street?.isBlank == false && building?.isBlank == false && alternateNumber?.isBlank == false && alternateNumber?.count == 8 {
                return true
            }
        }else if type?.lowercased() == "A".lowercased() || type?.lowercased() == "O".lowercased() {
            if name?.isBlank == false && locationID?.isBlank == false && type?.isBlank == false && block?.isBlank == false && street?.isBlank == false && building?.isBlank == false && floor?.isBlank == false && suitNo?.isBlank == false && alternateNumber?.isBlank == false && alternateNumber?.count == 8 {
                return true
            }
        }
        return false
    }
}
