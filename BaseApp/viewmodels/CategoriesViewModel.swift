//
//  CategoriesViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/06/2024.
//

import Foundation
import Combine

class CategoriesViewModel: NSObject {
    
    @Published var loading: Bool = false
    @Published var categoryLoading: Bool = false
    @Published var productsLoading: Bool = false
    @Published var loadMore: Bool = false
    @Published var products: Products?
    @Published var moreProducts: Products?
    @Published var subCategories: SubCategories?
    @Published var categories: Categories?
    @Published var vendors: Vendors?
    
    private var _SubCategories: SubCategories?
    private var _Categories: Categories?
    private var cancellables = Set<AnyCancellable>()
    private var currentCategoryPublisher: AnyCancellable?
    private var currentSubCategoryPublisher: AnyCancellable?
    private var currentProductPublisher: AnyCancellable?
    
    
    private func loadCategories() -> AnyPublisher<Categories?, Error> {
        return Future { promise in
            ExploreControllerAPI.categories { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func loadSubCategories(categoryId: String) -> AnyPublisher<SubCategories?, Error> {
        return Future { promise in
            ProductsControllerAPI.productsSubCategories(vendorId: nil, categoryId: categoryId) { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    @MainActor private func loadProducts(categoryId: String, subcategoryId: String, pageIndex: Int, pageSize: Int, pricefrom: String? = nil, priceto: String? = nil , vendorID: String? = nil) -> AnyPublisher<Products?, Error> {
        let body = ProductsParameters(
            eventDate: OcassionDate.shared.getDate(),
            categoryID: categoryId,
            subcategoryID: subcategoryId,
            pageindex: "\(pageIndex)",
            pagesize: "\(pageSize)",
            pricefrom: pricefrom,
            vendorID: vendorID,
            priceto: priceto,
            locationID: OcassionLocation.shared.getAreaId(),
            customerID: User.load()?.details?.id
        )
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
    
    @MainActor  func loadCategoriesAndThenLoadSubCategoriesAndThenLoadProducts(categoryId:String ,pageIndex: Int, pageSize: Int) {
        currentCategoryPublisher?.cancel()
        self.loading = true
        currentCategoryPublisher = loadCategories()
            .flatMap { categories -> AnyPublisher<SubCategories?, Error> in
                self._Categories = categories
                return self.loadSubCategories(categoryId: categoryId)
            }
            .flatMap { subcategories -> AnyPublisher<Products?, Error> in
                self._SubCategories = subcategories
                if self._SubCategories?.subcategories?.isEmpty == false{
                    self._SubCategories?.subcategories?.insert(Category(id: "", name: "All products", arName: "كل المنتجات", productType: "", mediaID: "", imageURL: "" , isSelected: true), at: 0)
                }
                return self.loadProducts(categoryId: categoryId, subcategoryId: "", pageIndex: pageIndex, pageSize: pageSize)
            }.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.loading = false
                switch completion {
                case .finished:
                    print("All API calls completed successfully.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { products in
                self.categories = self._Categories
                self.subCategories = self._SubCategories
                self.products = products
            })
        
        currentCategoryPublisher?.store(in: &cancellables)
    }
    
    @MainActor func loadSubCategoriesAndThenLoadProducts(categoryId: String, pageIndex: Int, pageSize: Int) {
        currentSubCategoryPublisher?.cancel()
        self.categoryLoading = true
        currentSubCategoryPublisher = loadSubCategories(categoryId: categoryId)
            .flatMap { subcategories -> AnyPublisher<Products?, Error> in
                self._SubCategories = subcategories
                if self._SubCategories?.subcategories?.isEmpty == false{
                    self._SubCategories?.subcategories?.insert(Category(id: "", name: "All products", arName: "كل المنتجات", productType: "", mediaID: "", imageURL: "" , isSelected: true), at: 0)
                }
                return self.loadProducts(categoryId: categoryId, subcategoryId: "", pageIndex: pageIndex, pageSize: pageSize)
            }.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.categoryLoading = false
                switch completion {
                case .finished:
                    print("API calls completed successfully.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { products in
                self.subCategories = self._SubCategories
                self.products = products
            })
        
        currentSubCategoryPublisher?.store(in: &cancellables)
    }
    
    
    
    @MainActor func loadProducts(categoryId: String, subcategoryId: String, pageIndex: Int, pageSize: Int, isLoadMore:Bool = false, pricefrom: String? = nil, priceto: String? = nil ,vendorID: String? = nil){
        currentProductPublisher?.cancel()
        productsLoading = !isLoadMore
        currentProductPublisher = loadProducts(categoryId: categoryId, subcategoryId: subcategoryId, pageIndex: pageIndex, pageSize: pageSize, pricefrom: pricefrom, priceto: priceto, vendorID: vendorID).receive(on: DispatchQueue.main).sink { completion in
            self.productsLoading = false
            switch completion {
            case .finished:
                print("API calls completed successfully.")
            case .failure(let error):
                print("Error: \(error)")
            }
        } receiveValue: { products in
            if isLoadMore {
                self.moreProducts = products
            }else{
                self.products = products
            }
        }
        currentProductPublisher?.store(in: &cancellables)
    }
    
    
    func loadFilterVendors(eventDate:String? , locationID:String, categoryID:String, productType:String?, ocassionID:String){
        loading = true
        ProductsControllerAPI.filterVendors(eventDate: eventDate, locationID: locationID, categoryID: categoryID, productType: productType, ocassionID: ocassionID) { data, error in
            self.loading = false
            if let error = error {
                MainHelper.handleApiError(error)
            }else if let vendors = data{
                self.vendors = vendors
            }
        }
    }
  
    
}
