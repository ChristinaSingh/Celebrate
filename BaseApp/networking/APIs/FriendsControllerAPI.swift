//
//  FriendsControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import Foundation
import Alamofire

open class FriendsControllerAPI {
    
    
    open class func friends(completion: @escaping ((_ data: Friends?,_ error: Error?) -> Void)) {
        friendsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func friendsWithRequestBuilder() -> RequestBuilder<Friends> {
        let path = "/api/v3/friends"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Friends>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func friendsRequests(completion: @escaping ((_ data: Friends?,_ error: Error?) -> Void)) {
        friendsRequestsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func friendsRequestsWithRequestBuilder() -> RequestBuilder<Friends> {
        let path = "/api/friends/myinvites"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Friends>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func findFriends(name:String , completion: @escaping ((_ data: SearchFriendResult?,_ error: Error?) -> Void)) {
        findFriendsWithRequestBuilder(name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func findFriendsWithRequestBuilder(name:String ) -> RequestBuilder<SearchFriendResult> {
        let path = "/api/customer/find"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["username":name]) 
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SearchFriendResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    open class func addFriend(friendId:String , completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        addFriendsWithRequestBuilder(friendId: friendId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func addFriendsWithRequestBuilder(friendId:String ) -> RequestBuilder<AppResponse> {
        let path = "/api/friends"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["friend_custid":friendId])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func acceptRejectFriend(friendId:String, status:String , completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        acceptRejectWithRequestBuilder(friendId: friendId , status: status).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func acceptRejectWithRequestBuilder(friendId:String, status:String) -> RequestBuilder<AppResponse> {
        let path = "/api/friends/status"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["fid":friendId , "status":status])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    open class func friendLikes(friendId:String, completion: @escaping ((_ data: FriendLike?,_ error: Error?) -> Void)) {
        friendLikesWithRequestBuilder(friendId: friendId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func friendLikesWithRequestBuilder(friendId:String) -> RequestBuilder<FriendLike> {
        let path = "/api/v3/gifts/getfriendgiftfavourites"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["friend_id":friendId])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FriendLike>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func unfriend(friendId:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        unfriendWithRequestBuilder(friendId: friendId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func unfriendWithRequestBuilder(friendId:String) -> RequestBuilder<AppResponse> {
        let path = "/api/friends/remove"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["fid":friendId])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func friendsToAcceptGifts(completion: @escaping ((_ data: Friends?,_ error: Error?) -> Void)) {
        friendsToAcceptGiftsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func friendsToAcceptGiftsWithRequestBuilder() -> RequestBuilder<Friends> {
        let path = "/api/v3/friends/gifts"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Friends>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func friendAddress(friendId:String, completion: @escaping ((_ data: FriendAddress?,_ error: Error?) -> Void)) {
        friendAddressWithRequestBuilder(friendId: friendId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func friendAddressWithRequestBuilder(friendId:String) -> RequestBuilder<FriendAddress> {
        let path = "/api/address/friendaddress"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["friend_custid":friendId])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FriendAddress>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    open class func friendBirthDayReminder(friendId:String, status:Int, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        friendBirthDayReminderWithRequestBuilder(friendId: friendId, status: status).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func friendBirthDayReminderWithRequestBuilder(friendId:String, status:Int) -> RequestBuilder<AppResponse> {
        let path = "/api/friends/setreminder"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["remindme":status, "fid":friendId])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    
    
    
}
