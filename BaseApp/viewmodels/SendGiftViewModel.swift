//
//  SendGiftViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import Combine


class SendGiftViewModel:NSObject{
    @Published var loading: Bool = false
    @Published var error: Error?
    @Published var friends: Friends?
    @Published var subCategories: [PopUPSCategory]?
    
    func getFreindsList(){
        self.loading = true
        FriendsControllerAPI.friendsToAcceptGifts { data, error in
            self.loading = false
            if let error {
                self.error = error
            }else{
                self.friends = data
            }
        }
    }
    
    func getSubCategories(){
        self.loading = true
        ProductsControllerAPI.giftsSubCategories { data, error in
            self.loading = false
            if let error {
                self.error = error
            }else{
                self.subCategories = data?.data
            }
        }
    }
}
