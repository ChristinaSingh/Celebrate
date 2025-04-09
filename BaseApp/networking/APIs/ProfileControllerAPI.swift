//
//  ProfileControllerAPI.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/05/2024.
//

import Foundation
import Alamofire


open class ProfileControllerAPI{
    
    open class func updateProfile(name:String? , email:String? , mobile:String? , birthday:String? , username:String? , ispublic:String?, completion: @escaping ((_ data: User?,_ error: Error?) -> Void)) {
        updateProfileWithRequestBuilder(name: name, email: email, mobile: mobile, birthday: birthday, username: username, ispublic: ispublic).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func updateProfileWithRequestBuilder(name:String? , email:String? , mobile:String? , birthday:String? , username:String? , ispublic:String?) -> RequestBuilder<User> {
        let path = "/api/customer"
        let URLString = SwaggerClientAPI.basePath + path
        let params = ["name":name , "mobile":mobile , "phone":mobile , "birthday":birthday , "username":username , "ispublic":ispublic]
        
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: params)
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func favorites(subCatId:String, completion: @escaping ((_ data: FriendLike?,_ error: Error?) -> Void)) {
        favoritesWithRequestBuilder(subCatId: subCatId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func favoritesWithRequestBuilder(subCatId:String) -> RequestBuilder<FriendLike> {
        let path = "/api/v3/products/giftItems"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["subcategories":subCatId])
        let requestBuilder: RequestBuilder<FriendLike>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func updateFavorites(ids:String, subCatIds:String, completion: @escaping ((_ data: AppResponse?,_ error: Error?) -> Void)) {
        updateFavoritesWithRequestBuilder(ids: ids, subCatIds:subCatIds).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func updateFavoritesWithRequestBuilder(ids:String, subCatIds:String) -> RequestBuilder<AppResponse> {
        let path = "/api/v3/gifts/managegiftfavourites"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["product_id": ids, "subcategory_id":subCatIds])
        let requestBuilder: RequestBuilder<AppResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    
    open class func changePassword(password:String, mobile:String ,completion: @escaping ((_ data: User?,_ error: Error?) -> Void)) {
        changePasswordWithRequestBuilder(password: password, mobile: mobile).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func changePasswordWithRequestBuilder(password:String, mobile:String) -> RequestBuilder<User> {
        let path = "/api/v3/customer/updatePassword"
        let URLString = SwaggerClientAPI.basePath + path
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["password":password, "mobile": mobile, "confirmation_password":password])
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
    
    open class func getAvatars(completion: @escaping ((_ data: [AvatarResponse]?,_ error: Error?) -> Void)) {
        getAvatarsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func getAvatarsWithRequestBuilder() -> RequestBuilder<[AvatarResponse]> {
        let path = "/api/avatars"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[AvatarResponse]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: nil, isBody: false)
    }
    
    
    open class func updateAvatar(avatarId:String, completion: @escaping ((_ data: User?,_ error: Error?) -> Void)) {
        updateAvatarWithRequestBuilder(avatarId:avatarId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    open class func updateAvatarWithRequestBuilder(avatarId:String) -> RequestBuilder<User> {
        let path = "/api/customer"
        let URLString = SwaggerClientAPI.basePath + path
        let url = URLComponents(string: URLString)
        let paramters = JSONEncodingHelper.encodingParameters(forEncodableObject: ["avatarid":avatarId])
        let requestBuilder: RequestBuilder<User>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: paramters, isBody: true)
    }
}
