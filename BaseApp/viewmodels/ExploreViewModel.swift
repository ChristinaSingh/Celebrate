//
//  ExploreViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//

import Foundation
import Foundation

class ExploreViewModel: NSObject {
    
    @Published var loading: Bool = false
    @Published var vendorLoading: Bool = false
    
    @Published var banners: Banners?
    private var _Banners : Banners?
    
//    @Published var corprate: Banners?
//    private var _Corprate : Banners?
    
    @Published var categories: Categories?
    private var _Categories : Categories?
    
    @Published var vendor: Vendor?
    
    @Published var vendors: Vendors?
    private var _Vendors : Vendors?
    
    @Published var newArrivals: NewArrivals?
    private var _NewArrivals : NewArrivals?
    
    @Published var offers: NewArrivals?
    private var _Offers : NewArrivals?
    
    @Published var topPicks: NewArrivals?
    private var _TopPicks : NewArrivals?
    
    @Published var planners: Planners?
    private var _Planners : Planners?
    
    @Published var error: Error?
    
    let dispatchGroup = DispatchGroup()
    private var cancelled = false
    
    func loadData(eventDate:String? = nil , eventLocation:String? = nil , userId:String? = nil) {
        cancelAllRequests()
        loading = true
        cancelled = false
        getBanners()
        getCategories()
        getVendors(eventDate: eventDate, eventLocation: eventLocation)
        getNewArrivals(userId: userId)
//        getCorprate()
        getOffers()
        getTopPicks(userId: userId)
        getPlanners()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.loading = false
            if !self.cancelled {
                self.updatePublishedProperties()
            }
        }
    }
    
    private func updatePublishedProperties() {
        self.banners = self._Banners
        self.categories = self._Categories
        self.vendors = self._Vendors
        self.newArrivals = self._NewArrivals
//        self.corprate = self._Corprate
        self.offers = self._Offers
        self.topPicks = self._TopPicks
        self.planners = self._Planners
    }
    
    func cancelAllRequests() {
        cancelled = true
    }
    
    private func getBanners() {
        dispatchGroup.enter()
        ExploreControllerAPI.banners { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
                //MainHelper.handleApiError(error)
            } else {
                self._Banners = data
            }
        }
    }
    
    private func getCategories() {
        dispatchGroup.enter()
        ExploreControllerAPI.categories { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
               // MainHelper.handleApiError(error)
            } else {
                self._Categories = data
            }
        }
    }
    
    private func getVendors(eventDate:String? = nil , eventLocation:String? = nil) {
        dispatchGroup.enter()
        ExploreControllerAPI.vendors(body: VendorsBody(eventDate: eventDate, locationID: eventLocation, start: "1", size: "20")) { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
                //MainHelper.handleApiError(error)
            } else {
                self._Vendors = data
            }
        }
    }
    
    func getVendorDetails(vendorId:String) {
        vendorLoading = true
        ExploreControllerAPI.vendorDetails(vendorId: vendorId) { data, error in
            self.vendorLoading = false
            if let error = error {
                self.error = error
            } else {
                self.vendor = data
            }
        }
    }
    
    private func getNewArrivals(userId:String? = nil) {
        dispatchGroup.enter()
        ExploreControllerAPI.newArrivals(userId: userId) { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
               // MainHelper.handleApiError(error)
            } else {
                self._NewArrivals = data
            }
        }
    }
    
//    private func getCorprate() {
//        dispatchGroup.enter()
//        ExploreControllerAPI.corprate { data, error in
//            defer { self.dispatchGroup.leave() }
//            guard !self.cancelled else { return }
//            if let error = error {
//                self.error = error
//              //  MainHelper.handleApiError(error)
//            } else {
//                self._Corprate = data
//            }
//        }
//    }
    
    private func getOffers() {
        dispatchGroup.enter()
        ExploreControllerAPI.offers { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
               // MainHelper.handleApiError(error)
            } else {
                self._Offers = data
            }
        }
    }
    
    private func getTopPicks(userId:String? = nil) {
        dispatchGroup.enter()
        ExploreControllerAPI.topPicks(userId: userId) { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
              //  MainHelper.handleApiError(error)
            } else {
                self._TopPicks = data
            }
        }
    }
    
    private func getPlanners() {
        dispatchGroup.enter()
        ExploreControllerAPI.planners { data, error in
            defer { self.dispatchGroup.leave() }
            guard !self.cancelled else { return }
            if let error = error {
                self.error = error
               // MainHelper.handleApiError(error)
            } else {
                self._Planners = data
            }
        }
    }
}
