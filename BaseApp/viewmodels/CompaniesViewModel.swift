//
//  CompaniesViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import Foundation
import Combine


class CompaniesViewModel:NSObject {
    
    @Published var loading: Bool = false
    var loadMore: Bool = false
    @Published var vendors: Vendors?
    @Published var searchedVendors: Vendors?
    @Published var moreVendors: Vendors?
    @Published var topPicks: NewArrivals?
    private var _TopPicks : NewArrivals?
    @Published var products: Products?
    @Published var subproducts: Products?
    @Published var moreProducts: Products?
    private var _Products : Products?
    @Published var subCategories: SubCategories?
    private var _SubCategories : SubCategories?
    @Published var productsLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var currentProductPublisher: AnyCancellable?
    
    let dispatchGroup = DispatchGroup()
    
    func getVendors(body:VendorsBody , loadMore:Bool = false){
        if loadMore == false{
            loading = true
        }else {
            self.loadMore = true
        }
        ExploreControllerAPI.vendors(body:body) { data, error in
            if loadMore == false{
                self.loading = false
            }else{
                self.loadMore = false
            }
            if error != nil {
                MainHelper.handleApiError(error)
            }else{
                if loadMore{
                    self.moreVendors = data
                }else{
                    self.vendors = data
                }
            }
        }
    }
    
    
    func findVendors(text:String){
        loading = true
        ExploreControllerAPI.findVendor(text: text) { data, error in
            self.loading = false
            if error != nil {
                MainHelper.handleApiError(error)
            }else{
                self.searchedVendors = data
            }
        }
    }
    
    
    func loadProfile(parameters:ProductsParameters? = nil){
        loading.toggle()
        getTopPicks(vendorId: parameters?.vendorID)
        vendorProducts(body: parameters, loadMore: false, requiresDispatchGroup: true)
        getSubCategories(vendorId: parameters?.vendorID , categoryId: parameters?.categoryID)
        dispatchGroup.notify(queue: DispatchQueue.main){
            self.loading.toggle()
            if let topPicks = self._TopPicks {
                self.topPicks = topPicks
            }
            
            if let products = self._Products {
                self.products = products
            }
            
            if let subCategories = self._SubCategories {
                self.subCategories = subCategories
            }
        }
    }
    
    
    private func getTopPicks(vendorId:String? = nil){
        dispatchGroup.enter()
        ExploreControllerAPI.topPicks(vendorId: vendorId) { data, error in
            if error != nil {
                MainHelper.handleApiError(error)
            }else{
                self._TopPicks = data
            }
            self.dispatchGroup.leave()
        }
    }
    
   
    func vendorProducts(body:ProductsParameters?, loadMore:Bool = false, requiresDispatchGroup:Bool = false){
        currentProductPublisher?.cancel()
        if requiresDispatchGroup {
            dispatchGroup.enter()
        }else{
            productsLoading = !loadMore
        }
        currentProductPublisher = loadProducts(body: body).receive(on: DispatchQueue.main).sink { completion in
            self.productsLoading = false
            switch completion {
            case .finished:
                print("API calls completed successfully.")
            case .failure(let error):
                print("Error: \(error)")
            }
        } receiveValue: { products in
            if requiresDispatchGroup {
                self._Products = products
                self.dispatchGroup.leave()
            }else{
                if loadMore {
                    self.moreProducts = products
                }else{
                    self.subproducts = products
                }
            }
        }
        currentProductPublisher?.store(in: &cancellables)
    }
    
    
    private func loadProducts(body:ProductsParameters?) -> AnyPublisher<Products?, Error> {
        print(body.convertToString ?? "")
        return Future { promise in
            ProductsControllerAPI.products(body: body) { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    private func getSubCategories(vendorId:String? = nil , categoryId:String? = nil){
        dispatchGroup.enter()
        ProductsControllerAPI.vendorsSubCategories(vendorId: vendorId, categoryId: categoryId) { data, error in
            if error != nil {
                MainHelper.handleApiError(error)
            }else{
                self._SubCategories = data
            }
            self.dispatchGroup.leave()
        }
    }
    
}
