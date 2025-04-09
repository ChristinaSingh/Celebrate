//
//  AddressesControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import Foundation
import Alamofire

open class AddressesControllerAPI{
    
    open class func addresses(locationId:String, completion: @escaping ((_ data: Addresses?,_ error: Error?) -> Void)) {
        addressessWithRequestBuilder(locationId: locationId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func addressessWithRequestBuilder(locationId:String) -> RequestBuilder<Addresses> {
        let path = "/api/address/location/\(locationId)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Addresses>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func deleteAddresse(addressId:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        deleteAddressessWithRequestBuilder(addressId: addressId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func deleteAddressessWithRequestBuilder(addressId:String) -> RequestBuilder<AppResponse> {
        let path = "/api/address/\(addressId)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func addAddresse(body:AddressBody, completion: @escaping ((_ data: Address?,_ error: Error?) -> Void)) {
        addAddressWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func addAddressWithRequestBuilder(body:AddressBody) -> RequestBuilder<Address> {
        let path = "/api/address"
        let URLString = SwaggerClientAPI.basePath + path
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Address>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    
    open class func editAddresse(body:Address, completion: @escaping ((_ data: Address?,_ error: Error?) -> Void)) {
        editAddressWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func editAddressWithRequestBuilder(body:Address) -> RequestBuilder<Address> {
        let path = "/api/address/\(body.id ?? "")"
        let URLString = SwaggerClientAPI.basePath + path
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Address>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func shareAddress(body:Address, status:String, completion: @escaping ((_ data: Address?,_ error: Error?) -> Void)) {
        shareAddressWithRequestBuilder(body: body, status: status).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func shareAddressWithRequestBuilder(body:Address, status:String) -> RequestBuilder<Address> {
        let path = "/api/address/\(body.id ?? "")"
        let URLString = SwaggerClientAPI.basePath + path
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["isshared": status])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Address>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
}
