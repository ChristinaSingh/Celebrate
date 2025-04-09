//
//  Question.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/11/2024.
//

import Foundation


public enum QuestionType: String, Codable {
    case Video
    case QR
    case Choices
    case Code
    case none
}

public struct Answers{
    let answerEn:String?
    let answerAr:String?
    var isCorrect:Bool?
    var isSelected:Bool = false
    
    
    init(answerEn: String? = nil, answerAr: String? = nil, isCorrect: Bool? = nil, isSelected: Bool = false) {
        self.answerEn = answerEn
        self.answerAr = answerAr
        self.isCorrect = isCorrect
        self.isSelected = isSelected
    }
}

public struct Question: Codable {
    let status:String?
    let description:String?
    let questionid, question, questionAr: String?
    let questionType, questionOption1, questionOption1Ar, questionOption2: String?
    let questionOption2Ar, questionOption3, questionOption3Ar, questionOption4: String?
    let questionOption4Ar, questionAnswer: String?
    let questionHint: String?
    let questionHintAr: String?
    var opencamera: Qty?
    var openlink: Qty?
    let gotolocation, gotolocationAr: String?
    let gotolocationImg:String?
    let browseapp: Qty?
    let starttime:String?
    let timelimit:String?
    let remainingTime:Int?
    let seconds:Int?
    let lifes, fails, skips, fiftyfiftys: Int?
    var wastas, haswasta, hasskip: Int?
    let customerrewardcount, allowfiftyfifty: Int?
    var hasfiftyfifty:Int?
    var isAnswered:Bool = false
    var answer:String = ""
    var isUsedFifty:Bool = false
    
    
    init(status: String?, description: String?, questionid: String?, question: String?, questionAr: String?, questionType: String?, questionOption1: String?, questionOption1Ar: String?, questionOption2: String?, questionOption2Ar: String?, questionOption3: String?, questionOption3Ar: String?, questionOption4: String?, questionOption4Ar: String?, questionAnswer: String?, questionHint: String?, questionHintAr: String?, opencamera: Qty? = nil, openlink: Qty? = nil, gotolocation: String?, gotolocationAr: String?, gotolocationImg: String?, browseapp: Qty?, starttime: String?, timelimit: String?, remainingTime: Int?, seconds: Int?, lifes: Int?, fails: Int?, skips: Int?, fiftyfiftys: Int?, wastas: Int? = nil, haswasta: Int? = nil, hasskip: Int? = nil, customerrewardcount: Int?, allowfiftyfifty: Int?, hasfiftyfifty: Int? = nil, isAnswered: Bool, answer: String, isUsedFifty: Bool) {
        self.status = status
        self.description = description
        self.questionid = questionid
        self.question = question
        self.questionAr = questionAr
        self.questionType = questionType
        self.questionOption1 = questionOption1
        self.questionOption1Ar = questionOption1Ar
        self.questionOption2 = questionOption2
        self.questionOption2Ar = questionOption2Ar
        self.questionOption3 = questionOption3
        self.questionOption3Ar = questionOption3Ar
        self.questionOption4 = questionOption4
        self.questionOption4Ar = questionOption4Ar
        self.questionAnswer = questionAnswer
        self.questionHint = questionHint
        self.questionHintAr = questionHintAr
        self.opencamera = opencamera
        self.openlink = openlink
        self.gotolocation = gotolocation
        self.gotolocationAr = gotolocationAr
        self.gotolocationImg = gotolocationImg
        self.browseapp = browseapp
        self.starttime = starttime
        self.timelimit = timelimit
        self.remainingTime = remainingTime
        self.seconds = seconds
        self.lifes = lifes
        self.fails = fails
        self.skips = skips
        self.fiftyfiftys = fiftyfiftys
        self.wastas = wastas
        self.haswasta = haswasta
        self.hasskip = hasskip
        self.customerrewardcount = customerrewardcount
        self.allowfiftyfifty = allowfiftyfifty
        self.hasfiftyfifty = hasfiftyfifty
        self.isAnswered = isAnswered
        self.answer = answer
        self.isUsedFifty = isUsedFifty
    }

    func getAnswers() -> [Answers]{
        var answers:[Answers] = []
        if let questionOption1 = questionOption1 {
            let answer1 = Answers(answerEn: questionOption1, answerAr: questionOption1Ar ?? "", isCorrect: false)
            answers.append(answer1)
        }
        
        if let questionOption2 = questionOption2 {
            let answer2 = Answers(answerEn: questionOption2, answerAr: questionOption2Ar ?? "", isCorrect: false)
            answers.append(answer2)
        }
        
        if let questionOption3 = questionOption3 {
            let answer3 = Answers(answerEn: questionOption3, answerAr: questionOption3Ar ?? "", isCorrect: false)
            answers.append(answer3)
        }
        
        if let questionOption4 = questionOption4 {
            let answer4 = Answers(answerEn: questionOption4, answerAr: questionOption4Ar ?? "", isCorrect: false)
            answers.append(answer4)
        }
        
        if let questionAnswer = questionAnswer {
            let answerIndex = Int(questionAnswer) ?? 0
            if answerIndex > 0 {
                if answers.count > 0 {
                    answers[answerIndex - 1].isCorrect = true
                }
            }
        }
        if isUsedFifty {
            var answersTemp : [Answers] = []
            for (index , ans) in answers.enumerated() {
                if answers[safe: index]?.isCorrect == true{
                    answersTemp.append(ans)
                    answers.remove(at: index)
                    break
                }
            }
            if let ans = answers[safe: 0]{
                answersTemp.append(ans)
            }
            answers = answersTemp.shuffled()
        }
        return answers
    }
    
    
    func type() -> QuestionType {
        if let _ = openlink{
            return .Video
        }else if let opencamera = opencamera, opencamera.integer == 1 || opencamera.string == "1" {
            return .QR
        }else if questionType ?? "" == "1" || questionType ?? "" == "3"{
            return .Choices
        }else if questionType ?? "" == "2" {
            return .Code
        }else {
            return .none
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status, questionid, question
        case questionAr = "question_ar"
        case questionType = "question_type"
        case questionOption1 = "question_option1"
        case questionOption1Ar = "question_option1_ar"
        case questionOption2 = "question_option2"
        case questionOption2Ar = "question_option2_ar"
        case questionOption3 = "question_option3"
        case questionOption3Ar = "question_option3_ar"
        case questionOption4 = "question_option4"
        case questionOption4Ar = "question_option4_ar"
        case questionAnswer = "question_answer"
        case questionHint = "question_hint"
        case questionHintAr = "question_hint_ar"
        case opencamera, openlink, gotolocation
        case gotolocationAr = "gotolocation_ar"
        case browseapp
        case starttime
        case timelimit
        case remainingTime = "timeremain_minutes"
        case gotolocationImg = "gotolocation_image"
        case description
        case seconds = "timeremain_seconds"
        case lifes, fails, skips, fiftyfiftys, wastas, hasfiftyfifty, haswasta, hasskip, customerrewardcount, allowfiftyfifty
    }
}
