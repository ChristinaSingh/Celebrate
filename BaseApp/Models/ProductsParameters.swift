//
//  ProductsParameters.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import Foundation
public class ProductsParameters: Codable {
    var eventDate, categoryID, subcategoryID, ocassionID: String?
    var pageindex, pagesize, pricefrom, vendorID: String?
    var priceto, sortbyName, locationID, searchtxt: String?
    var customerID: String?

    enum CodingKeys: String, CodingKey {
        case eventDate, categoryID, subcategoryID, ocassionID, pageindex, pagesize, pricefrom, vendorID, priceto
        case sortbyName = "sortby_name"
        case locationID, searchtxt, customerID
    }
    
    
    init(eventDate: String? = nil, categoryID: String? = nil, subcategoryID: String? = nil, ocassionID: String? = nil, pageindex: String? = nil, pagesize: String? = nil, pricefrom: String? = nil, vendorID: String? = nil, priceto: String? = nil, sortbyName: String? = nil, locationID: String? = nil, searchtxt: String? = nil, customerID: String? = nil) {
        self.eventDate = eventDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.ocassionID = ocassionID
        self.pageindex = pageindex
        self.pagesize = pagesize
        self.pricefrom = pricefrom
        self.vendorID = vendorID
        self.priceto = priceto
        self.sortbyName = sortbyName
        self.locationID = locationID
        self.searchtxt = searchtxt
        self.customerID = customerID
    }
}
