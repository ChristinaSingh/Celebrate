//
//  AddressesViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import Foundation
import Combine

class AddressesViewModel:NSObject {
    @Published var loading: Bool = false
    @Published var shareLoading: Bool = false
    @Published var changeLoading: Bool = false
    @Published var error: Error?
    @Published var addresses: Addresses?
    @Published var addressEdited: Address?
    @Published var addressAdded: Address?
    @Published var sharedAddress: Address?
    @Published var changedAddress: Address?
    
    func getAddresses(locationId:String = ""){
        loading = true
        AddressesControllerAPI.addresses(locationId: locationId){ data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.addresses = data
            }
        }
    }
    
    func addAddress(address:AddressBody){
        loading = true
        AddressesControllerAPI.addAddresse(body: address){ data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.addressAdded = data
            }
        }
    }
    
    
    func editAddress(address:Address){
        loading = true
        AddressesControllerAPI.editAddresse(body: address){ data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.addressEdited = data
            }
        }
    }
    
    
    func shareAddress(address:Address, status:String, isChange:Bool){
        if isChange {
            changeLoading = true
        }else {
            shareLoading = true
        }
        AddressesControllerAPI.shareAddress(body: address, status: status){ data, error in
            if isChange {
                self.changeLoading = false
            }else{
                self.shareLoading = false
            }
            if error != nil {
                self.error = error
            }else{
                if isChange {
                    self.changedAddress = data
                }else{
                    self.sharedAddress = data
                }
            }
        }
    }
    
    
    func deleteAddress(addressId:String , callback: @escaping ((AppResponse? , Error?) async -> Void)){
        AddressesControllerAPI.deleteAddresse(addressId: addressId) { data, error in
            Task{
                await callback(data , error)
            }
        }
    }
}
