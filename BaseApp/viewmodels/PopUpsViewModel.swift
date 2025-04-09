//
//  PopUpsViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/11/2024.
//

import Foundation
import Combine

class PopUpsViewModel: ObservableObject {
    @Published var loading: Bool = false
    @Published var loadingSubCategories: Bool = false
    @Published var error: Error?
    @Published var categories:PopUPSCategories?
    @Published var subCategories:PopUPSubSCategories?
    @Published var governorates: Governorates?
    @Published var locations:PopUpLocations?
    @Published var items: Products?
    @Published var times: PreferredTimes?
    @Published var setupIsReady: PreferredTimes?
    @Published var vendor: Vendor?
    
    func getDeliveryTimes(){
        loading = true
        PopUpsControllerAPI.getDeliveryTimes { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.times = data
            }
        }
    }
    
    func getReservationCategories(){
        loading = true
        PopUpsControllerAPI.getReservationCategories { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.categories = data
            }
        }
    }
    
    
    func getSubCategories(id:String){
        loadingSubCategories = true
        PopUpsControllerAPI.getSubCategories(id: id) { data, error in
            self.loadingSubCategories = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.subCategories = data
            }
        }
    }
    
    
    func getLocations(governateId:String, categoryId:String){
        loadingSubCategories = true
        PopUpsControllerAPI.getPopUpLocations(governateId: governateId, categoryId: categoryId) { data, error in
            self.loadingSubCategories = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.locations = data
            }
        }
    }
    
    
    func getRestraunts(governateId:String){
        loadingSubCategories = true
        PopUpsControllerAPI.getRestrauntsLocations(governateId: governateId) { data, error in
            self.loadingSubCategories = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.locations = data
            }
        }
    }
    
    
    func getGovernorates(){
        loadingSubCategories = true
        PopUpsControllerAPI.getGovernorates() { data, error in
            self.loadingSubCategories = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.governorates = data
            }
        }
    }
    
    
    func getProducts(){
        loading = true
        PopUpsControllerAPI.getSetupsProducts{ data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.items = data
            }
        }
    }
    
    
    func getRestrauntItems(){
        loading = true
        PopUpsControllerAPI.getRestrauntProducts{ data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.items = data
            }
        }
    }
    
    func isSetupReady(){
        PopUpsControllerAPI.getDeliveryTimes { data, error in
            if let error = error {
                self.error = error
            }else if let data = data {
                self.setupIsReady = data
            }
        }
    }
    
    
    func getVendorDetails(vendorId:String) {
        loadingSubCategories = true
        ExploreControllerAPI.vendorDetails(vendorId: vendorId) { data, error in
            self.loadingSubCategories = false
            if let error = error {
                self.error = error
            } else {
                self.vendor = data
            }
        }
    }
}
