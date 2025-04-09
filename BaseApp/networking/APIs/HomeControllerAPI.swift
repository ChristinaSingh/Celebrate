//
//  CelebrateControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import Foundation
import Alamofire


open class HomeControllerAPI{
    
    open class func orders(completion: @escaping ((_ data: Carts?,_ error: Error?) -> Void)) {
        ordersWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func ordersWithRequestBuilder() -> RequestBuilder<Carts> {
        let path = "/api/v3/cart/pendingApprovalItemsStatus"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Carts>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
   
    
    
}
