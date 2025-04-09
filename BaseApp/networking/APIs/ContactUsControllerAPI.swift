//
//  ContactUsControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import Foundation
import Alamofire


open class ContactUsControllerAPI{
    
    open class func contactUs(name:String, email:String, mobile:String, message:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        contactUsWithRequestBuilder(name: name, email: email, mobile: mobile, message: message).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func contactUsWithRequestBuilder(name:String, email:String, mobile:String, message:String) -> RequestBuilder<AppResponse> {
        let path = "/api/contactus"
        let URLString = SwaggerClientAPI.basePath + path
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["name":name , "email":email , "mobile":mobile , "comments":message])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
}
