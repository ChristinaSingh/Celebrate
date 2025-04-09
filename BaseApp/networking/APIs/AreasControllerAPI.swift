//
//  AreasControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/08/2024.
//

import Foundation
open class AreasControllerAPI{
    
    open class func areas(completion: @escaping ((_ data: Areas?,_ error: Error?) -> Void)) {
        areasWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func areasWithRequestBuilder() -> RequestBuilder<Areas> {
        let path = "/api/GovernoratesWithLocations"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Areas>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
}
