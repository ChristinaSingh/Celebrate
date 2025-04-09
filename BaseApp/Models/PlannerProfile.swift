//
//  PlannerProfile.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/06/2024.
//

public struct PlannerProfileElement: Codable {
    let id, name, nameAr, contactperson: String?
    let mobile, telephone: String?
    let iconURL, coverpageURL: String?
    let rating, aboutus , aboutusAr: String?
    let status, sortorder: String?
    let specialities: [Speciality]?
    let gallery: [Gallery]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case contactperson, mobile, telephone
        case iconURL = "icon_url"
        case coverpageURL = "coverpage_url"
        case rating, aboutus, status, sortorder, specialities, gallery
        case aboutusAr = "aboutus_ar"
    }
}

// MARK: - Gallery
public struct Gallery: Codable {
    let id, eventPlannerID: String?
    let imageURL: String?
    let imageDesc, imageDescAr, addeddate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventPlannerID = "EventPlannerId"
        case imageURL = "ImageUrl"
        case imageDesc = "ImageDesc"
        case imageDescAr = "ImageDesc_ar"
        case addeddate
    }
}

// MARK: - Speciality
public struct Speciality: Codable {
    let id, name, nameAr: String?
    let imageURL: String?
    let status, sortorder: String?
    let imageURLAr: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case imageURL = "image_url"
        case status, sortorder
        case imageURLAr = "image_url_ar"
    }
}

public typealias PlannerProfile = [PlannerProfileElement]
