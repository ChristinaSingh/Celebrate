//
//  SurpriseIntro.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/10/2024.
//

import Foundation

public struct SurpriseIntro: Codable {
    
    let status:String?
    let introText1, introText1_Ar, introText2: String?
    let introText2_Ar, introText3, introText3_Ar: String?
    let correctcount: String?
    let skipcount, wrongcount, fiftyfiftycount, wastacount: String?
    let timelimit, wastacode, wastatext, wastatextAr: String?
    let revivetext, revivetextAr: String?
    let wastaimg, reviveimg: String?
    let wastatitle, wastatitleAr: String?
    let homepagetext, homepagetextAr, homepageimg: String?
    let customerstartedgame: Int?
    let closinglocation: Closinglocation?
    let entrybycode, customerrewardcount: Int?
    
    
    init(status: String? = nil, introText1: String? = nil, introText1_Ar: String? = nil, introText2: String? = nil, introText2_Ar: String? = nil, introText3: String? = nil, introText3_Ar: String? = nil, correctcount: String? = nil, skipcount: String? = nil, wrongcount: String? = nil, fiftyfiftycount: String? = nil, wastacount: String? = nil, timelimit: String? = nil, wastacode: String? = nil, wastatext: String? = nil, wastatextAr: String? = nil, revivetext: String? = nil, revivetextAr: String? = nil, wastaimg: String? = nil, reviveimg: String? = nil, wastatitle: String? = nil, wastatitleAr: String? = nil, homepagetext: String? = nil, homepagetextAr: String? = nil, homepageimg: String? = nil, customerstartedgame: Int? = nil, closinglocation: Closinglocation?  = nil, entrybycode: Int?  = nil, customerrewardcount: Int?  = nil) {
        self.status = status
        self.introText1 = introText1
        self.introText1_Ar = introText1_Ar
        self.introText2 = introText2
        self.introText2_Ar = introText2_Ar
        self.introText3 = introText3
        self.introText3_Ar = introText3_Ar
        self.correctcount = correctcount
        self.skipcount = skipcount
        self.wrongcount = wrongcount
        self.fiftyfiftycount = fiftyfiftycount
        self.wastacount = wastacount
        self.timelimit = timelimit
        self.wastacode = wastacode
        self.wastatext = wastatext
        self.wastatextAr = wastatextAr
        self.revivetext = revivetext
        self.revivetextAr = revivetextAr
        self.wastaimg = wastaimg
        self.reviveimg = reviveimg
        self.wastatitle = wastatitle
        self.wastatitleAr = wastatitleAr
        self.homepagetext = homepagetext
        self.homepagetextAr = homepagetextAr
        self.homepageimg = homepageimg
        self.customerstartedgame = customerstartedgame
        self.closinglocation = closinglocation
        self.entrybycode = entrybycode
        self.customerrewardcount = customerrewardcount
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case introText1 = "intro_text_1"
        case introText1_Ar = "intro_text_1_ar"
        case introText2 = "intro_text_2"
        case introText2_Ar = "intro_text_2_ar"
        case introText3 = "intro_text_3"
        case introText3_Ar = "intro_text_3_ar"
        case correctcount, skipcount, wrongcount, fiftyfiftycount, wastacount, timelimit, wastacode, wastatext
        case wastatextAr = "wastatext_ar"
        case revivetext, wastatitle
        case wastatitleAr = "wastatitle_ar"
        case revivetextAr = "revivetext_ar"
        case wastaimg, reviveimg, homepagetext
        case homepagetextAr = "homepagetext_ar"
        case homepageimg, customerstartedgame, closinglocation, entrybycode, customerrewardcount
    }
}


// MARK: - Closinglocation
public struct Closinglocation: Codable {
    let closinglocationLat, closinglocationLon, closinglocationtext, closinglocationtextAr: String?
    let closinglocationimg: String?

    init(closinglocationLat: String?  = nil, closinglocationLon: String?  = nil, closinglocationtext: String?  = nil, closinglocationtextAr: String?  = nil, closinglocationimg: String?  = nil) {
        self.closinglocationLat = closinglocationLat
        self.closinglocationLon = closinglocationLon
        self.closinglocationtext = closinglocationtext
        self.closinglocationtextAr = closinglocationtextAr
        self.closinglocationimg = closinglocationimg
    }
    enum CodingKeys: String, CodingKey {
        case closinglocationLat = "closinglocation_lat"
        case closinglocationLon = "closinglocation_lon"
        case closinglocationtext
        case closinglocationtextAr = "closinglocationtext_ar"
        case closinglocationimg
    }
}
