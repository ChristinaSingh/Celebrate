//
//  ProductsViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import Foundation
import Combine


class ProductsViewModel:NSObject {
    
    @Published var loading: Bool = false
    @Published var addToWishListloading: Bool = false
    @Published var removeFromWishListloading: Bool = false
    @Published var error: Error?
    @Published var addToWishListError: Error?
    @Published var removeFromWishListError: Error?
    @Published var productAddedToWishList: AppResponse?
    @Published var productRemovedFromWishList: AppResponse?
    @Published var productDetails: ProductDetails?
    @Published var wishList: Products?
    @Published var offers: Products?
    @Published var newarrivals: Products?
    @Published var featured: Products?
    @Published var productTimeSlots: DeliveryTimes?
    

    
    @MainActor func getDetails(productId:String? , userId:String?, date:String? = nil, locationId:String? = nil){
        loading = true
        let body = ProductDetailsBody(eventDate: date == nil ? OcassionDate.shared.getDate() : date, locationID: locationId == nil ? OcassionLocation.shared.getAreaId() : locationId , productID: productId, customerID: userId)
        ProductsControllerAPI.productDetails(body: body) { data, error in
            self.loading = false
            if error != nil {
                MainHelper.handleApiError(error)
            }else{
                self.productDetails = data
            }
        }
    }
    
    
    
    func getTimeSlots(productId:String?, date:String?){
        loading = true
        ProductsControllerAPI.productTimeSlots(eventDate: date, productID: productId) { data, error in
            self.loading = false
            if error != nil {
                MainHelper.handleApiError(error)
            }else{
                self.productTimeSlots = data
            }
        }
    }
    
    func getWishList(body:ProductsParameters){
        loading = true
        ProductsControllerAPI.wishList(body: body) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.wishList = data
            }
        }
    }
    
    
    func gifts(subcategories:String){
        loading = true
        ProductsControllerAPI.gifts(subcategories: subcategories) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.wishList = data
            }
        }
    }
    
    func getFriendLikes(friendId:String){
        loading = true
        FriendsControllerAPI.friendLikes(friendId: friendId) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.wishList = Products(products: data?.data, totalrecords: nil, pagecount: nil)
            }
        }
    }
    
    
    func offers(body:ProductsParameters){
        loading = true
        ProductsControllerAPI.offers(body: body) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.offers = data
            }
        }
    }
    
    
    func newarrivals(body:ProductsParameters){
        loading = true
        ProductsControllerAPI.newarrivals { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.newarrivals = data
            }
        }
    }
    
    
    func featured(body:ProductsParameters){
        loading = true
        ProductsControllerAPI.featured { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.featured = data
            }
        }
    }
    
    
    func addProductToWishList(productId:String){
        addToWishListloading = true
        ProductsControllerAPI.addProductToWishList(productId: productId) { data, error in
            self.addToWishListloading = false
            if error != nil {
                self.addToWishListError = error
            }else{
                self.productAddedToWishList = data
            }
        }
    }
    
    
    func removeProductFromWishList(productId:String){
        removeFromWishListloading = true
        ProductsControllerAPI.removeProductToWishList(productId: productId) { data, error in
            self.removeFromWishListloading = false
            if error != nil {
                self.removeFromWishListError = error
            }else{
                self.productRemovedFromWishList = data
            }
        }
    }
}
