//
//  PopUpLocations.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/11/2024.
//

import Foundation
import MapKit

// MARK: - PopUpLocations
public struct PopUpLocations: Codable {
    let status: Bool?
    let message: String?
    let data: [PopUpLocation]?
    
    init(status: Bool? = nil, message: String? = nil, data: [PopUpLocation]? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

extension PopUpLocations {
    func toCoordinates() -> [CLLocationCoordinate2D] {
        guard let locations = data else { return [] }
        return locations.compactMap { location in
            guard
                let latString = location.locationLat,
                let lngString = location.locationLng,
                let latitude = Double(latString),
                let longitude = Double(lngString)
            else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}

// MARK: - Datum
public struct PopUpLocation: Codable {
    let id, vendorID, name, nameAr: String?
    let description, descriptionAr, locationLat, locationLng: String?
    let governateID, cityID, fromHour, toHour: String?
    let deliveryCharge, categoryID, subcategoryID, status: String?
    let logo:String?
    let rate:Double?
    let services: [String]?
    let governate, city: City?
    let images: [String]?
    let viewCompany:Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case nameAr = "name_ar"
        case description
        case descriptionAr = "description_ar"
        case locationLat = "location_lat"
        case locationLng = "location_lng"
        case governateID = "governate_id"
        case cityID = "city_id"
        case fromHour = "from_hour"
        case toHour = "to_hour"
        case logo
        case rate = "avg_rate"
        case deliveryCharge = "delivery_charge"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case viewCompany = "company_view"
        case status, services, governate, city, images
    }
    
    func getServices() -> [LocationService]? {
        guard let services = services else { return [] }
        return services.compactMap(LocationService.init(rawValue:))
    }
}

// MARK: - Service
enum LocationService:String ,Codable {
    case SportFields = "sport_fields"
    case RestRooms = "restrooms"
    case Restaurants = "restaurants_and_cafes"
    case Cuisine = "cuisine"
    case KidsArea = "kids_area"
    case PrayerRoom = "prayer_room"
    case ValetParking = "valet_parking"
    case CelebrationSinging = "celebration_singing"
    case PrivateAccess = "private_access"
    case RoofTop = "rooftop"
    case TerraceBalcony = "terrace_balcony"
    case SmokeArea = "smoking_area"
    case CelebrationCakeSweets = "celebration_cake_sweets"
    case PrivateCabinetRoom = "private_cabinet_room"
    case McHosts = "mc_hosts"
    case Decorations = "decorations"
    case GamesAndActivities = "games_and_activities"
    case CelebrationCakes = "celebration_cakes"
    case GiveAways = "giveaways"
}

struct City: Codable {
    let id, name, governateID, arName: String?
    let popupLocationDeliveryCharge: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case governateID = "governate_id"
        case arName = "ar_name"
        case popupLocationDeliveryCharge = "popup_location_delivery_charge"
    }
}
