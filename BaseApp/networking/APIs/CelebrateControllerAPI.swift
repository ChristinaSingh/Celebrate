//
//  CelebrateControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import Foundation
import Alamofire


open class CelebrateControllerAPI{
    
    open class func timeSlots(completion: @escaping ((_ data: TimeSlots?,_ error: Error?) -> Void)) {
        timeSlotsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func timeSlotsWithRequestBuilder() -> RequestBuilder<TimeSlots> {
        let path = "/api/v3/assistant/deliverytimes"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TimeSlots>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func occassions(completion: @escaping ((_ data: Occasions?,_ error: Error?) -> Void)) {
        occassionsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func occassionsWithRequestBuilder() -> RequestBuilder<Occasions> {
        let path = "/api/v3/assistant/ocassions"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Occasions>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func categories(occasions:String ,completion: @escaping ((_ data: Categories?,_ error: Error?) -> Void)) {
        categoriesWithRequestBuilder(occasions: occasions).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func categoriesWithRequestBuilder(occasions:String) -> RequestBuilder<Categories> {
        let path = "/api/v3/assistant/categories"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["occassions":occasions])
       
        
        let requestBuilder: RequestBuilder<Categories>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    
    open class func subcategories(categories:String, occasions:String ,completion: @escaping ((_ data: Categories?,_ error: Error?) -> Void)) {
        subcategoriesWithRequestBuilder(categories: categories, occasions: occasions).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func subcategoriesWithRequestBuilder(categories:String, occasions:String) -> RequestBuilder<Categories> {
        let path = "/api/v3/assistant/subcategories"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["occassions":occasions, "categories":categories])
       
        
        let requestBuilder: RequestBuilder<Categories>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func inputs(subcategories:String ,completion: @escaping ((_ data: CelebrateInputs?,_ error: Error?) -> Void)) {
        inputsWithRequestBuilder(subcategories: subcategories).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func inputsWithRequestBuilder(subcategories:String) -> RequestBuilder<CelebrateInputs> {
        let path = "/api/v3/assistant/getinputs"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["subcategories":subcategories])
       
        
        let requestBuilder: RequestBuilder<CelebrateInputs>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func getPrices(subcategories:String ,completion: @escaping ((_ data: CelebrateAvaragePrice?,_ error: Error?) -> Void)) {
        getPricesWithRequestBuilder(subcategories: subcategories).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getPricesWithRequestBuilder(subcategories:String) -> RequestBuilder<CelebrateAvaragePrice> {
        let path = "/api/v3/assistant/getavgprice"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["subcategories":subcategories])
       
        
        let requestBuilder: RequestBuilder<CelebrateAvaragePrice>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    
    open class func bundles(body:BundleBody ,completion: @escaping ((_ data: BundlesResponse?,_ error: Error?) -> Void)) {
        bundlesWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func bundlesWithRequestBuilder(body:BundleBody) -> RequestBuilder<BundlesResponse> {
        let path = "/api/v3/assistant/getbundles"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)
       
        
        let requestBuilder: RequestBuilder<BundlesResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func getOptions(bundleItems:String ,completion: @escaping ((_ data: BundleOptions?,_ error: Error?) -> Void)) {
        getOptionsWithRequestBuilder(bundleItems: bundleItems).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getOptionsWithRequestBuilder(bundleItems:String) -> RequestBuilder<BundleOptions> {
        let path = "/api/v3/assistant/bundleItemsOptions"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["bundleItems":bundleItems])
       
        
        let requestBuilder: RequestBuilder<BundleOptions>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    
    open class func addToCart(body:AddBundleToCartBody ,completion: @escaping ((_ data: Cart?,_ error: Error?) -> Void)) {
        addToCartWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func addToCartWithRequestBuilder(body: AddBundleToCartBody) -> RequestBuilder<Cart> {
        let path = "/api/v3/cart/aiassistantitems"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)
       
        
        let requestBuilder: RequestBuilder<Cart>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    
    
    
}
