//
//  ConfigurationControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/01/2025.
//

import Foundation
import Alamofire


class ConfigurationControllerAPI {
    
    open class func getAppVersion(completion: @escaping ((_ data: AppVersion?,_ error: Error?) -> Void)) {
        getAppVersionWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    open class func getAppVersionWithRequestBuilder() -> RequestBuilder<AppVersion> {
        let path = "/api/v3/general/appversion"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<AppVersion>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()
        
        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
}
