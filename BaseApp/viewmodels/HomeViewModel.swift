//
//  CelebrateViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var error: Error?
    @Published var orders: Carts?
    
    func loadPendingOrders(){
        loading = true
        HomeControllerAPI.orders { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.orders = data
            }
        }
    }
    
}
