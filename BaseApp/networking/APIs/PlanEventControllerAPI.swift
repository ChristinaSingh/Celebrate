//
//  PlannerControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/06/2024.
//

import Alamofire


open class PlanEventControllerAPI{
    
    open class func plannerProfile(plannerId:String?, completion: @escaping ((_ data: PlannerProfile?,_ error: Error?) -> Void)) {
        plannerProfileWithRequestBuilder(plannerId: plannerId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func plannerProfileWithRequestBuilder(plannerId:String?) -> RequestBuilder<PlannerProfile> {
        let path = "/api/v3/eventplanner/list/\(plannerId ?? "")"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PlannerProfile>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func plannerTimes(selecteddate:String, eventplannerid:String, completion: @escaping ((_ data: PreferredTimes?,_ error: Error?) -> Void)) {
        plannerTimesWithRequestBuilder(selecteddate: selecteddate, eventplannerid: eventplannerid).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func plannerTimesWithRequestBuilder(selecteddate:String, eventplannerid:String) -> RequestBuilder<PreferredTimes> {
        let path = "/api/v3/eventplanner/getpreferredtimes"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["eventplannerid":eventplannerid , "selecteddate":selecteddate])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PreferredTimes>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func bookNow(selecteddate:String, eventplannerid:String, preferredtime:String, mobile:String, name:String, preferredtimeid:String, additionalinfo:String? = nil, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        bookNowWithRequestBuilder(selecteddate: selecteddate, eventplannerid: eventplannerid, preferredtime: preferredtime, mobile: mobile, name: name, preferredtimeid: preferredtimeid, additionalinfo: additionalinfo).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func bookNowWithRequestBuilder(selecteddate:String, eventplannerid:String, preferredtime:String, mobile:String, name:String, preferredtimeid:String, additionalinfo:String? = nil) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/eventplanner/bookappointment"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["eventplannerid":eventplannerid , "eventdate":selecteddate, "preferredtime":preferredtime, "mobile":mobile, "name":name, "preferredtimeid":preferredtimeid, "additionalinfo":additionalinfo ?? ""])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func occasions(plannerId:String, completion: @escaping ((_ data: PlanEventOccasions?,_ error: Error?) -> Void)) {
        occasionsWithRequestBuilder(plannerId: plannerId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func occasionsWithRequestBuilder(plannerId:String) -> RequestBuilder<PlanEventOccasions> {
        let path = "/api/v3/eventplanner/getSpecialitiesByPlannerId/\(plannerId)"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PlanEventOccasions>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }


    open class func venuTypes(completion: @escaping ((_ data: VenueTypes?,_ error: Error?) -> Void)) {
        venuTypesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func venuTypesWithRequestBuilder() -> RequestBuilder<VenueTypes> {
        let path = "/api/v3/Eventplanner/getEventPlannerVenueTypes"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<VenueTypes>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func hotels(completion: @escaping ((_ data: VenueHotels?,_ error: Error?) -> Void)) {
        hotelsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func hotelsWithRequestBuilder() -> RequestBuilder<VenueHotels> {
        let path = "/api/v3/Eventplanner/getEventPlannerHotels"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<VenueHotels>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    open class func createEvent(body:PlanEventBody ,completion: @escaping ((_ data: PlanEventResponse?,_ error: Error?) -> Void)) {
        createEventWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func createEventWithRequestBuilder(body:PlanEventBody) -> RequestBuilder<PlanEventResponse> {
        let path = "/api/v3/Eventplanner/createEventPlanningApplication"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)
        let requestBuilder: RequestBuilder<PlanEventResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func needReplacement(body:ReplacementRequest ,completion: @escaping ((_ data: ReplacementResponse?,_ error: Error?) -> Void)) {
        needReplacementWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func needReplacementWithRequestBuilder(body:ReplacementRequest) -> RequestBuilder<ReplacementResponse> {
        let path = "/api/v3/Eventplanner/needReplacement"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)
        let requestBuilder: RequestBuilder<ReplacementResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
}
