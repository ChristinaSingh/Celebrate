//
// AuthControllerAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire

open class AuthControllerAPI {
 
    open class func login(playerId:String , mobile:String , password:String, completion: @escaping ((_ data: User?,_ error: Error?) -> Void)) {
        loginWithRequestBuilder(playerId: playerId, mobile: mobile, password: password).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func loginWithRequestBuilder(playerId:String , mobile:String , password:String) -> RequestBuilder<User> {
        let path = "/api/v3/customer/login"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["playerId":playerId, "mobile":mobile, "password":password])

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    open class func createAccount(username:String , mobile:String, password:String , playerId:String, completion: @escaping ((_ data: User?,_ error: Error?) -> Void)) {
        createAccountWithRequestBuilder(username: username, mobile: mobile, password: password, playerId: playerId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func createAccountWithRequestBuilder(username:String , mobile:String, password:String , playerId:String) -> RequestBuilder<User> {
        let path = "/api/v3/customer"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["username":username, "mobile":mobile , "password":password , "playerId":playerId])

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    open class func checkIfMobileNumberExists(phoneNumber:String, otpRequired:Bool, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        checkIfMobileNumberExistsWithRequestBuilder(phoneNumber: phoneNumber, otpRequired: otpRequired).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func checkIfMobileNumberExistsWithRequestBuilder(phoneNumber:String , otpRequired:Bool) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/customer/checkmobileexists"
        let URLString = SwaggerClientAPI.basePath + path
        
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: [
            "mobile":phoneNumber,
            "otp": otpRequired ? "y" : "n"
        ])

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    open class func checkIfUserNameExists(username:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        checkIfUserNamesWithRequestBuilder(username: username).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func checkIfUserNamesWithRequestBuilder(username:String) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/customer/checkusernameexists"
        let URLString = SwaggerClientAPI.basePath + path
        
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: [
            "username":username
        ])

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func verifyOtp(body:OtpVerificationBody, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        verifyOtpWithRequestBuilder(body: body).execute { (response, error) -> Void in
            
            print("response \(response) response \(response?.body) error \(error)")
            completion(response?.body, error)
        }
    }

    open class func verifyOtpWithRequestBuilder(body:OtpVerificationBody) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/customer/verifyotp"
        let URLString = SwaggerClientAPI.basePath + path
        
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    open class func resendOtp(body:OtpVerificationBody, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        resendOtpWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func resendOtpWithRequestBuilder(body:OtpVerificationBody) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/customer/resendotp"
        let URLString = SwaggerClientAPI.basePath + path
        
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func deleteAccount(completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        deleteAccountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func deleteAccountWithRequestBuilder() -> RequestBuilder<AppResponse> {
        let path = "/api/customer/unregister"
        let URLString = SwaggerClientAPI.basePath + path
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    open class func resetPassword(mobile:String, completion: @escaping ((_ data: ResetPassword?,_ error: Error?) -> Void)) {
        resetPasswordWithRequestBuilder(mobile: mobile).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func resetPasswordWithRequestBuilder(mobile:String) -> RequestBuilder<ResetPassword> {
        let path = "/api/v3/customer/passwordresetotp"
        let URLString = SwaggerClientAPI.basePath + path
        
        let url = URLComponents(string: URLString)
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: [
            "mobile":mobile
        ])
        let requestBuilder: RequestBuilder<ResetPassword>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    


}
