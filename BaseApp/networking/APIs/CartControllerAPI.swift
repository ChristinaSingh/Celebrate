//
//  CartControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 22/08/2024.
//

import Foundation
open class CartControllerAPI{
    
    open class func cart(completion: @escaping ((_ data: Carts?,_ error: Error?) -> Void)) {
        cartWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func cartWithRequestBuilder() -> RequestBuilder<Carts> {
        let path = "/api/v3/cart"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Carts>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    
    open class func createCart(locationID:String, deliveryDate:String, addressID:String?, ocassionID:String, cartType: CartType, popupLocationID: String? , popupLocationDate: PopupLocationDate?, cartTime:String?, friendID:String?, completion: @escaping ((_ data: Cart?,_ error: Error?) -> Void)) {
        createCartWithRequestBuilder(locationID: locationID, deliveryDate: deliveryDate, addressID: addressID, ocassionID: ocassionID, cartType: cartType, popupLocationID: popupLocationID, popupLocationDate: popupLocationDate, cartTime: cartTime, friendID: friendID).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func createCartWithRequestBuilder(locationID:String, deliveryDate:String, addressID:String?, ocassionID:String, cartType: CartType, popupLocationID: String? , popupLocationDate: PopupLocationDate?, cartTime:String?, friendID:String?) -> RequestBuilder<Cart> {
        let path = "/api/v3/cart"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let body = CreateCartBody(ocassionID: ocassionID, locationID: popupLocationID == nil ? locationID : popupLocationID, deliveryDate: popupLocationDate?.date == nil ? deliveryDate : popupLocationDate?.date, cartType: cartType, popupLocationID: popupLocationID, popupLocationDate: popupLocationDate, addressID: addressID, cartTime: cartTime, friendID: friendID)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let requestBuilder: RequestBuilder<Cart>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func addItemToCart(item:CartBody, completion: @escaping ((_ data: Cart?,_ error: Error?) -> Void)) {
        addItemToCartWithRequestBuilder(item:item).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func addItemToCartWithRequestBuilder(item:CartBody) -> RequestBuilder<Cart> {
        let path = "/api/v3/cart/item"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        print(item.convertToString ?? "")
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: item)

        let requestBuilder: RequestBuilder<Cart>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func deleteCart(id:String, completion: @escaping ((_ data: Carts?,_ error: Error?) -> Void)) {
        deleteCartWithRequestBuilder(id:id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func deleteCartWithRequestBuilder(id:String) -> RequestBuilder<Carts> {
        let path = "/api/cart/\(id)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Carts>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func deleteItemFromCart(id:String, cartId:String, completion: @escaping ((_ data: Cart?,_ error: Error?) -> Void)) {
        deleteItemFromCartWithRequestBuilder(id:id, cartId: cartId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func deleteItemFromCartWithRequestBuilder(id:String, cartId:String) -> RequestBuilder<Cart> {
        let path = "/api/cart/itemdelete"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["groupHash":id, "cartID":cartId])
        let requestBuilder: RequestBuilder<Cart>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }


    open class func applyVoucher(vouchercode:String, completion: @escaping ((_ data: Carts?,_ error: Error?) -> Void)) {
        applyVoucherWithRequestBuilder(vouchercode:vouchercode).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func applyVoucherWithRequestBuilder(vouchercode:String) -> RequestBuilder<Carts> {
        let path = "/api/cart/applyvoucher"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["vouchercode":vouchercode])
        let requestBuilder: RequestBuilder<Carts>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func removeVoucher(completion: @escaping ((_ data: Carts?,_ error: Error?) -> Void)) {
        removeVoucherWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func removeVoucherWithRequestBuilder() -> RequestBuilder<Carts> {
        let path = "/api/cart/removevoucher"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let requestBuilder: RequestBuilder<Carts>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func orderAddress(cartId:String , addressId:String , friendFlag:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        orderAddressWithRequestBuilder(cartId:cartId , addressId:addressId , friendFlag:friendFlag).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    
    open class func orderAddressWithRequestBuilder(cartId:String , addressId:String , friendFlag:String) -> RequestBuilder<AppResponse> {
        let path = "/api/cart/updateaddress"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["cartID":cartId , "addressID":addressId , "friendFlag":friendFlag])
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func convertCartToOrder(cartId:String, completion: @escaping ((_ data: Orders?,_ error: Error?) -> Void)) {
        convertCartToOrderWithRequestBuilder(cartId:cartId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func convertCartToOrderWithRequestBuilder(cartId:String) -> RequestBuilder<Orders> {
        let path = "/api/v3/cart/convert"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["cartID":cartId])
        let requestBuilder: RequestBuilder<Orders>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func pendingApprovalRequest(request:PendingApprovalRequest, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        pendingApprovalRequestWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func pendingApprovalRequestWithRequestBuilder(request:PendingApprovalRequest) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/cart/changePendingApprovalStatus"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func applePay(cartId: String, clientIp: String, applepaydata: String , orderID:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        applePayWithRequestBuilder(cartId:cartId, clientIp: clientIp, applepaydata: applepaydata, orderID: orderID).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func applePayWithRequestBuilder(cartId: String, clientIp: String, applepaydata: String , orderID:String) -> RequestBuilder<AppResponse> {
        let path = "/pg/gotap/testrequestapple"
        let URLString = SwaggerClientAPI.basePath + path
        var url = URLComponents(string: URLString)
        url?.queryItems = [
            URLQueryItem(name: "customerID", value: User.load()?.details?.id),
                URLQueryItem(name: "cartID", value: cartId),
                URLQueryItem(name: "paymenttype", value: "applepay"),
                URLQueryItem(name: "clientIp", value: clientIp),
                URLQueryItem(name: "data", value: applepaydata),
                URLQueryItem(name: "orderID", value: orderID)
            ]
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    
    open class func times(completion: @escaping ((_ data: PreferredTimes?,_ error: Error?) -> Void)) {
        timesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func timesWithRequestBuilder() -> RequestBuilder<PreferredTimes> {
        let path = "/api/v3/cart/times"
        let URLString = SwaggerClientAPI.basePath + path
      
        let requestBuilder: RequestBuilder<PreferredTimes>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: nil, isBody: false)
    }
    
    open class func updateTime(cartId:String, time:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        updateTimeWithRequestBuilder(cartId:cartId, time:time).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func updateTimeWithRequestBuilder(cartId:String, time:String) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/cart/updateCartTime"
        let URLString = SwaggerClientAPI.basePath + path
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["cartId":cartId , "cart_time":time])
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: paramters, isBody: true)
    }
    
}
