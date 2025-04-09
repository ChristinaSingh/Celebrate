//
//  PopUpsController.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/11/2024.
//

import Foundation
import Alamofire


class PopUpsControllerAPI {
    
    
    open class func getReservationCategories(completion: @escaping ((_ data: PopUPSCategories?,_ error: Error?) -> Void)) {
        getReservationCategoriesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getReservationCategoriesWithRequestBuilder() -> RequestBuilder<PopUPSCategories> {
        let path = "/api/v3/category/getReservationCategories"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PopUPSCategories>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func getSubCategories(id:String, completion: @escaping ((_ data: PopUPSubSCategories?,_ error: Error?) -> Void)) {
        getSubCategoriesWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getSubCategoriesWithRequestBuilder(id:String) -> RequestBuilder<PopUPSubSCategories> {
        let path = "/api/v3/category/getSubCategories?parent_id=\(id)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PopUPSubSCategories>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func getPopUpLocations(governateId:String, categoryId:String, completion: @escaping ((_ data: PopUpLocations?,_ error: Error?) -> Void)) {
        getPopUpLocationsWithRequestBuilder(governateId: governateId, categoryId:categoryId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getPopUpLocationsWithRequestBuilder(governateId:String, categoryId:String) -> RequestBuilder<PopUpLocations> {
        let path = "/api/v3/vendors/getPopUpLocations?governate_id=\(governateId)&category_id=\(categoryId)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PopUpLocations>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    open class func getRestrauntsLocations(governateId:String, completion: @escaping ((_ data: PopUpLocations?,_ error: Error?) -> Void)) {
        getRestrauntsLocationsWithRequestBuilder(governateId: governateId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getRestrauntsLocationsWithRequestBuilder(governateId:String) -> RequestBuilder<PopUpLocations> {
        let path = "/api/v3/vendors/getRestaurantsPopUpLocations?governate_id=\(governateId)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PopUpLocations>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func getGovernorates(completion: @escaping ((_ data: Governorates?,_ error: Error?) -> Void)) {
        getGovernoratesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getGovernoratesWithRequestBuilder() -> RequestBuilder<Governorates> {
        let path = "/api/v3/GovernoratesWithLocations/popup"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Governorates>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func getSetupsProducts(completion: @escaping ((_ data: Products?,_ error: Error?) -> Void)) {
        getSetupsProductsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getSetupsProductsWithRequestBuilder() -> RequestBuilder<Products> {
        let path = "/api/v3/products/setupItems"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Products>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func getRestrauntProducts(completion: @escaping ((_ data: Products?,_ error: Error?) -> Void)) {
        getRestrauntProductsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getRestrauntProductsWithRequestBuilder() -> RequestBuilder<Products> {
        let path = "/api/v3/products/tableItems"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Products>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func getDeliveryTimes(completion: @escaping ((_ data: PreferredTimes?,_ error: Error?) -> Void)) {
        getDeliveryTimesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getDeliveryTimesWithRequestBuilder() -> RequestBuilder<PreferredTimes> {
        let path = "/api/v3/vendors/preferredtimes"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PreferredTimes>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
}
