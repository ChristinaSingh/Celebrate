//
//  SubmitAnswer.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
public struct SubmitAnswer: Codable {
    
    public enum Status: String, Codable, CaseIterable {
        case TIMEEXCEEDED = "TIMEEXCEEDED"
        case SKIPNOTALLOWED = "SKIPNOTALLOWED"
        case NOGAMESESSIONS = "NOGAMESESSIONS"
        case SUCCESS = "SUCCESS"
    }
    
    let status: Status?
    let isEnded: Bool?
    let isWinner: Bool?
    let playVideo: String?
    let totalquestions, answered: String?
    let lifes ,fails, skips: Int?
    let reviveavailable:Int?
    let error:String?
    let closinglocation: Closinglocation?
    
    init(status: Status? = nil, isEnded: Bool? = nil, isWinner: Bool? = nil, playVideo: String? = nil, totalquestions: String? = nil, answered: String? = nil, lifes: Int? = nil, fails: Int? = nil, skips: Int? = nil, reviveavailable: Int? = nil, error: String? = nil, closinglocation: Closinglocation? = nil) {
        self.status = status
        self.isEnded = isEnded
        self.isWinner = isWinner
        self.playVideo = playVideo
        self.totalquestions = totalquestions
        self.answered = answered
        self.lifes = lifes
        self.fails = fails
        self.skips = skips
        self.reviveavailable = reviveavailable
        self.error = error
        self.closinglocation = closinglocation
    }
}

