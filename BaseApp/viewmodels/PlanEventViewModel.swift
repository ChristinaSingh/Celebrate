//
//  PlanEventViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//

import Foundation
class PlanEventViewModel:NSObject{
    
    @Published var loading: Bool = false
    @Published var bookLoading: Bool = false
    @Published var error: Error?
    @Published var plannerProfile: PlannerProfile?
    @Published var planners: Planners?
    @Published var times: PreferredTimes?
    @Published var bookPlanner: AppResponse?
    @Published var replacement: ReplacementResponse?
    @Published var planEvent: PlanEventResponse?
    @Published var occasions: PlanEventOccasions = []
    @Published var venueTypes: [VenueType] = []
    @Published var hotels: [VenueHotel] = []
    
    
    func plannerProfile(plannerId:String?){
        loading = true
        PlanEventControllerAPI.plannerProfile(plannerId: plannerId) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.plannerProfile = data
            }
        }
    }
    
    
    func loadPlanners(){
        loading = true
        ExploreControllerAPI.planners { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            } else {
                self.planners = data
            }
        }

    }
    
    
    func times(selecteddate:String, eventplannerid:String){
        loading = true
        PlanEventControllerAPI.plannerTimes(selecteddate: selecteddate, eventplannerid: eventplannerid) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            } else {
                self.times = data
            }
        }
    }
    
    
    
    func bookPlanner(selecteddate:String, eventplannerid:String, preferredtime:String, mobile:String, name:String, preferredtimeid:String, additionalinfo:String? = nil){
        self.bookLoading = true
        PlanEventControllerAPI.bookNow(selecteddate: selecteddate, eventplannerid: eventplannerid, preferredtime: preferredtime, mobile: mobile, name: name, preferredtimeid: preferredtimeid, additionalinfo: additionalinfo) { data, error in
            self.bookLoading = false
            if let error = error {
                self.error = error
            } else {
                self.bookPlanner = data
            }
        }
    }
    
    
    func getOccasions(plannerId:String){
        loading = true
        PlanEventControllerAPI.occasions(plannerId: plannerId) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            } else {
                self.occasions = data ?? []
            }
        }
    }
    
    func getVenueTypes(){
        loading = true
        PlanEventControllerAPI.venuTypes { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            } else {
                self.venueTypes = data?.data ?? []
            }
        }
    }
    
    
    func getHotels(){
        loading = true
        PlanEventControllerAPI.hotels { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            } else {
                self.hotels = data?.data ?? []
            }
        }
    }
    
    func createEvent(body:PlanEventBody) {
        print("Event to be create \(body.convertToString ?? "")")
        bookLoading = true
        PlanEventControllerAPI.createEvent(body: body) { data, error in
            self.bookLoading = false
            if let error = error {
                self.error = error
            } else {
                self.planEvent = data
            }
        }
    }
    
    func replacement(body:ReplacementRequest) {
        print("Event to be create \(body.convertToString ?? "")")
        bookLoading = true
        PlanEventControllerAPI.needReplacement(body: body) { data, error in
            self.bookLoading = false
            if let error = error {
                self.error = error
            } else {
                self.replacement = data
            }
        }
    }
}
