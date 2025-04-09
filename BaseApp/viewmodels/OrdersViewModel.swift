//
//  OrdersViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Combine
import Foundation

class OrdersViewModel:NSObject{
    
    @Published var loading: Bool = false
    @Published var indicatorLoading: Bool = false
    @Published var error: Error?
    @Published var orders: Orders?
    @Published var orderDetails: Order?
    @Published var postponeOrder: AppResponse?
    @Published var cancelOrder: AppResponse?
    @Published var rateOrder: AppResponse?
    
    
    func orders(page:Int){
        loading = true
        OrdersControllerAPI.orders(pageIndex: "\(page)", pageSize: "100") { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.orders = data
            }
        }
    }
    
    
    func orderDetails(orderId:String){
        loading = true
        OrdersControllerAPI.orderDetails(orderId: orderId) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.orderDetails = data
            }
        }
    }
    
    
    func postponeOrder(orderId:String, vendorId:String, date:String){
        indicatorLoading = true
        OrdersControllerAPI.postponeOrder(orderId: orderId, vendorId: vendorId, date: date) { data, error in
            self.indicatorLoading = false
            if error != nil {
                self.error = error
            }else{
                self.postponeOrder = data
            }
        }
    }
    
    
    func cancelOrder(orderId:String, reason:String){
        indicatorLoading = true
        OrdersControllerAPI.cancelOrder(orderId: orderId, reason: reason) { data, error in
            self.indicatorLoading = false
            if error != nil {
                self.error = error
            }else{
                self.cancelOrder = data
            }
        }
    }
    
    func rateOrder(orderId:String, rating:String, comment:String){
        loading = true
        OrdersControllerAPI.rateOrder(orderId: orderId, rating: rating, comments: comment) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.rateOrder = data
            }
        }
    }
}
