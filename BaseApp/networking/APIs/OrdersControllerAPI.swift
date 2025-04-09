//
//  OrdersControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Alamofire


open class OrdersControllerAPI{
    
    open class func orders(pageIndex:String , pageSize:String, completion: @escaping ((_ data: Orders?,_ error: Error?) -> Void)) {
        ordersWithRequestBuilder(pageIndex:pageIndex , pageSize:pageSize).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func ordersWithRequestBuilder(pageIndex:String , pageSize:String) -> RequestBuilder<Orders> {
        let path = "/api/v3/orders?offset=\(pageIndex)&limit=\(pageSize)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Orders>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    
    open class func orderDetails(orderId:String, completion: @escaping ((_ data: Order?,_ error: Error?) -> Void)) {
        orderDetailsWithRequestBuilder(orderId: orderId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func orderDetailsWithRequestBuilder(orderId:String) -> RequestBuilder<Order> {
        let path = "/api/v3/orders/\(orderId)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Order>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    
    open class func postponeOrder(orderId:String, vendorId:String, date:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        postponeOrderWithRequestBuilder(orderId: orderId, vendorId: vendorId, date: date).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func postponeOrderWithRequestBuilder(orderId:String, vendorId:String, date:String) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/orders/postponeorder"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: [
            "orderid":orderId,
            "vendorid":vendorId,
            "message":date
        ])

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: parameters, isBody: true)
    }
    
    
    open class func cancelOrder(orderId:String, reason:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        cancelOrderWithRequestBuilder(orderId: orderId, reason: reason).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func cancelOrderWithRequestBuilder(orderId:String, reason:String) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/orders/cancel/\(orderId)"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: [
            "cartId":orderId,
            "reason":reason
        ])
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: parameters, isBody: true)
    }
    
    open class func rateOrder(orderId:String, rating:String, comments:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        rateOrderWithRequestBuilder(orderId: orderId, rating: rating, comments: comments).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func rateOrderWithRequestBuilder(orderId:String, rating:String, comments:String) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/general/rating"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: [
            "orderid":orderId,
            "rating":rating,
            "comments":comments
        ])

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: parameters, isBody: true)
    }
}
