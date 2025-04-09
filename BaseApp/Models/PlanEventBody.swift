//
//  PlanEventBody.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//

import Foundation
public struct PlanEventBody: Codable {
    var fullName, eventDate, eventStartTime, eventEndTime: String?
    var budget, noOfGuests: String?
    var venueType, hotels, mobile, location: String?
    var additionalNotes: String?
    var customerID, eventPlannerID: String?
    var occasions:String?
    
    init(fullName: String? = nil, eventDate: String? = nil, eventStartTime: String? = nil, eventEndTime: String? = nil, budget: String? = nil, noOfGuests: String? = nil, venueType: String? = nil, hotels: String? = nil, mobile: String? = nil, location: String? = nil, additionalNotes: String? = nil, customerID: String? = nil, eventPlannerID: String?  = nil, occasions:String? = nil) {
        self.fullName = fullName
        self.eventDate = eventDate
        self.eventStartTime = eventStartTime
        self.eventEndTime = eventEndTime
        self.budget = budget
        self.noOfGuests = noOfGuests
        self.venueType = venueType
        self.hotels = hotels
        self.mobile = mobile
        self.location = location
        self.additionalNotes = additionalNotes
        self.customerID = customerID
        self.eventPlannerID = eventPlannerID
        self.occasions = occasions
    }

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case eventDate = "event_date"
        case eventStartTime = "event_start_time"
        case eventEndTime = "event_end_time"
        case budget
        case noOfGuests = "no_of_guests"
        case venueType = "venue_type"
        case hotels, mobile, location
        case additionalNotes = "additional_notes"
        case customerID = "customer_id"
        case eventPlannerID = "event_planner_id"
        case occasions = "speciality_id"
    }
}
