//
//  SurpriseControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/10/2024.
//

import Foundation
import Alamofire


class SurpriseControllerAPI {
    
    
    open class func intro(completion: @escaping ((_ data: SurpriseIntro?,_ error: Error?) -> Void)) {
        introWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func introWithRequestBuilder() -> RequestBuilder<SurpriseIntro> {
        let path = "/api/game/gameintro"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SurpriseIntro>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func signup(date:String, name:String, mobile:String, additionalinfo:String,completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        signupWithRequestBuilder(date: date, name: name, mobile: mobile, additionalinfo: additionalinfo).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func signupWithRequestBuilder(date:String, name:String, mobile:String, additionalinfo:String) -> RequestBuilder<AppResponse> {
        let path = "/api/game/signup"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["exp_date":date , "name":name , "mobile":mobile , "additionalinfo":additionalinfo])
        
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func verifyCode(code:String,completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        verifyCodeWithRequestBuilder(code: code).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func verifyCodeWithRequestBuilder(code:String) -> RequestBuilder<AppResponse> {
        let path = "/api/game/startgame"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["entrycode":code])
        
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func getQuestion(completion: @escaping ((_ data: Question?,_ error: Error?) -> Void)) {
        getQuestionWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getQuestionWithRequestBuilder() -> RequestBuilder<Question> {
        let path = "/api/game/getquestion"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<Question>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    
    open class func submitAnswer(answer:String , questionid:String , wrong:String , correct:String , skip:String , wasta:String , fiftyfifty:String,completion: @escaping ((_ data: SubmitAnswer?,_ error: Error?) -> Void)) {
        submitAnswerWithRequestBuilder(answer: answer, questionid: questionid, wrong: wrong, correct: correct, skip: skip, wasta: wasta, fiftyfifty: fiftyfifty).execute(isFormData: true) { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func submitAnswerWithRequestBuilder(answer:String , questionid:String , wrong:String , correct:String , skip:String , wasta:String , fiftyfifty:String) -> RequestBuilder<SubmitAnswer> {
        let path = "/api/game/submitanswer"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let parameters = ["answer":answer , "questionid":questionid , "wrong":wrong , "correct":correct, "skip":skip, "wasta":wasta, "fiftyfifty":fiftyfifty]
        let requestBuilder: RequestBuilder<SubmitAnswer>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func state(completion: @escaping ((_ data: SurpriseState?,_ error: Error?) -> Void)) {
        stateWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func stateWithRequestBuilder() -> RequestBuilder<SurpriseState> {
        let path = "/api/game/gamestats"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<SurpriseState>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func revive(code:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        reviveWithRequestBuilder(code: code).execute(isFormData: true) { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func reviveWithRequestBuilder(code:String) -> RequestBuilder<AppResponse> {
        let path = "/api/game/revive"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let parameters = ["revivecode":code]
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    
}
