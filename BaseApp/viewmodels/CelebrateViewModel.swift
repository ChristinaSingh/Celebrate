//
//  CelebrateViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import Foundation
import Combine


class CelebrateViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var inputsLoading: Bool = false
    @Published var error: Error?
    @Published var timeSlots: TimeSlots?
    @Published var occassions: Occasions?
    @Published var categories: Categories?
    @Published var subcategories: Categories?
    @Published var bundles: BundlesResponse?
    @Published var options: BundleOptions?
    @Published var inputs: CelebrateInputs?
    @Published var prices: CelebrateAvaragePrice?
    @Published var expiredCart: Cart?
    @Published var addedItemToCart: Cart?
    @Published var cartDeleted: Carts?
    private var cancellables = Set<AnyCancellable>()
    
    
    func loadTimeSlots(){
        loading = true
        CelebrateControllerAPI.timeSlots { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.timeSlots = data
            }
        }
    }
    
    
    func loadOccassions(){
        loading = true
        CelebrateControllerAPI.occassions { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.occassions = data
            }
        }
    }
    
    
    func loadCategories(occasions:String){
        loading = true
        CelebrateControllerAPI.categories(occasions: occasions) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.categories = data
            }
        }
    }
    
    
    func loadsubCategories(occasions:String, categories:String){
        loading = true
        CelebrateControllerAPI.subcategories(categories: categories, occasions: occasions) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.subcategories = data
            }
        }
    }
    
    
    func loadInputs(subCategories:String){
        inputsLoading = true
        CelebrateControllerAPI.inputs(subcategories: subCategories) { data, error in
            if let error = error {
                self.inputsLoading = false
                self.error = error
            }else if let data = data {
                let inputs:[Input] = []
                
                data.data?.subCategories?.forEach { category in
                    var inputs = category.inputs ?? []
                    inputs.forEachIndexed { index, _ in
                        inputs[safe:index]?.subCatId = category.id
                    }
                    inputs.append(contentsOf: category.inputs ?? [])
                }
                if inputs.isEmpty == false {
                    self.inputsLoading = false
                    self.inputs = data
                }else{
                    self.getPrices(subCategories: subCategories)
                }
            }
        }
    }
    
    
    func getPrices(subCategories:String){
        loading = true
        CelebrateControllerAPI.getPrices(subcategories: subCategories) { data, error in
            self.loading = false
            self.inputsLoading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.prices = data
            }
        }
    }
    
    
    func loadBundles(body: BundleBody){
        loading = true
        print("body \(body.convertToString ?? "")")
        CelebrateControllerAPI.bundles(body: body) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.bundles = data
            }
        }
    }
    
    func getOptions(bundleItems: String){
        loading = true
        CelebrateControllerAPI.getOptions(bundleItems: bundleItems) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.options = data
            }
        }
    }
    
    func addIBundleToCart(items: [CartBody], locationId:String, date:String, time:String, cartType: CartType, cartTime:String?) {
        loading = true
        getCarts()
            .flatMap { [unowned self] carts -> AnyPublisher<Cart, Error> in
                if let existingCart = carts.first {
                    if existingCart.cartType != cartType {
                        return Fail(error: CartError.typeMismatch(existingCart))
                                                .eraseToAnyPublisher()
                    }
                    return Just(existingCart)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.createCart(locationID: locationId,
                                           deliveryDate: date,
                                           addressID: "",
                                           occasionID: "1",
                                           cartType: cartType, cartTime: cartTime)
                }
            }
            .flatMap { [unowned self] cart -> AnyPublisher<Cart, Error> in
                return self.addIBundleToCart(items: items, cart: cart)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                self.loading = false
                if case .failure(let err) = completion {
                    self.error = err
                }
            }, receiveValue: { [unowned self] updatedCart in
                self.addedItemToCart = updatedCart
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cart.refresh"), object: nil)
            })
            .store(in: &cancellables)
    }
    
    private func addIBundleToCart(items: [CartBody], cart: Cart) -> AnyPublisher<Cart, Error> {
        self.expiredCart = nil
        return Future { promise in
            CelebrateControllerAPI.addToCart(body: AddBundleToCartBody(cartID: cart.id, products: items)) { data, error in
                if let error = error {
                    if let code = (error as? ErrorResponse) {
                        switch code {
                        case .error(let code,  _,  _):
                            if code == 406 {
                                self.expiredCart = cart
                            }else{
                                promise(.failure(error))
                            }
                        }
                    }else{
                        promise(.failure(error))
                    }
                    
                } else if let updatedCart = data {
                    promise(.success(updatedCart))
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to add item to cart"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    private func getCarts() -> AnyPublisher<[Cart], Error> {
        return Future { promise in
            CartControllerAPI.cart { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data ?? []))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createCart(locationID: String, deliveryDate: String, addressID: String, occasionID: String, cartType: CartType, cartTime:String?) -> AnyPublisher<Cart, Error> {
        return Future { promise in
            CartControllerAPI.createCart(locationID: locationID, deliveryDate: deliveryDate, addressID: addressID, ocassionID: occasionID, cartType: cartType, popupLocationID: nil, popupLocationDate: nil, cartTime: cartTime, friendID: nil) { data, error in
                if let error = error {
                    promise(.failure(error))
                } else if let createdCart = data {
                    promise(.success(createdCart))
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create cart"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteCart(id:String){
        self.loading = true
        CartControllerAPI.deleteCart(id: id) { data, error in
            self.loading = false
            if let carts = data {
                self.cartDeleted = carts
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cart.refresh"), object: nil)
            }
        }
    }
}
