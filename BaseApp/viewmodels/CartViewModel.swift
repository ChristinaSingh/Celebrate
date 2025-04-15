//
//  CartViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 22/08/2024.
//

import Foundation
import Combine

enum CartError: Error {
    case typeMismatch(Cart)
    case locationMismatch(Cart)
    case dateMismatch(Cart)
    case timeMismatch(Cart)
}

class CartViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var proceedLoading: Bool = false
    @Published var couponLoading: Bool = false
    @Published var expiredCart: Cart?
    @Published var error: Error?
    @Published var cart: Carts?
    @Published var cartDeleted: Carts?
    @Published var createdCart: Cart?
    @Published var addedItemToCart: Cart?
    @Published var applePay: AppResponse?
    @Published var pendingApproval: AppResponse?
    @Published var orderAddress: AppResponse?
    @Published var times: PreferredTimes?
    @Published var timeUpdated: AppResponse?
    @Published var cartOrder: Orders?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func addItemToCart(item: CartBody, cartType: CartType,  popupLocationID: String? , popupLocationDate: PopupLocationDate? ) {
        loading = true
        getCarts()
            .flatMap { [unowned self] carts -> AnyPublisher<Cart, Error> in
                if let existingCart = carts.first {
                    if existingCart.cartType != cartType {
                        return Fail(error: CartError.typeMismatch(existingCart))
                                                .eraseToAnyPublisher()
                    }else if existingCart.location?.locationID != (popupLocationID == nil ? item.locationID : popupLocationID) {
                        return Fail(error: CartError.locationMismatch(existingCart))
                            .eraseToAnyPublisher()
                    }else if existingCart.deliveryDate != item.deliveryDate {
                        return Fail(error: CartError.dateMismatch(existingCart))
                            .eraseToAnyPublisher()
                    }else if existingCart.cartTime != item.cartTime {
                        return Fail(error: CartError.timeMismatch(existingCart))
                            .eraseToAnyPublisher()
                    }
                    return Just(existingCart)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.createCart(locationID: item.locationID ?? "",
                                           deliveryDate: item.deliveryDate ?? "",
                                           addressID: item.addressid,
                                           occasionID: item.ocassionID ?? "",
                                           cartType: cartType, popupLocationID: popupLocationID, popupLocationDate: popupLocationDate, cartTime: item.cartTime, friendID: item.friendID)
                }
            }
            .flatMap { [unowned self] cart -> AnyPublisher<Cart, Error> in
                return self.addItemToCart(item: item, cart: cart)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                self.loading = false
                if case .failure(let err) = completion {
                    self.error = err
                }
            }, receiveValue: { [unowned self] updatedCart in
                self.addedItemToCart = updatedCart
//                self.getCarts()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cart.refresh"), object: "\(updatedCart.items?.count ?? 0)")
//                self.cart = Carts(carts: updatedCart.carts)
//                DispatchQueue.main.async {
//                    self.cart = [updatedCart]
//                }
                print("Item added, updated cart count: \(updatedCart.items?.count ?? 0)")
                //print("Item added2,self.cart count: \(self.cart?.count ?? 0)")

            })
            .store(in: &cancellables)
        print("Add item to cart: \(item)")
//        print("items in cart: \")
    }
    
    private func getCarts() -> AnyPublisher<[Cart], Error> {
        print("getCarts just ran")
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
    
    private func createCart(locationID: String, deliveryDate: String, addressID: String?, occasionID: String, cartType: CartType, popupLocationID: String? , popupLocationDate: PopupLocationDate?, cartTime:String?, friendID:String?) -> AnyPublisher<Cart, Error> {
        return Future { promise in
            CartControllerAPI.createCart(locationID: locationID, deliveryDate: deliveryDate, addressID: addressID, ocassionID: occasionID, cartType: cartType, popupLocationID: popupLocationID, popupLocationDate: popupLocationDate, cartTime: cartTime, friendID: friendID) { data, error in
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
    
    private func addItemToCart(item: CartBody, cart: Cart) -> AnyPublisher<Cart, Error> {
        self.expiredCart = nil
        print("AddItemToCart2 just ran")
        return Future { promise in
            var item = item
            item.cartID = cart.id
            CartControllerAPI.addItemToCart(item: item) { data, error in
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
    
    
    func fetchCarts() {
        loading = true
        getCarts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                self.loading = false
                if case .failure(let err) = completion {
                    self.error = err
                }
            }, receiveValue: { [unowned self] carts in
                self.cart = carts
            })
            .store(in: &cancellables)
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
    
    
    
    func applyCoupon(coupon:String){
        couponLoading = true
        CartControllerAPI.applyVoucher(vouchercode: coupon) { data, error in
            self.couponLoading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.cart = data
            }
        }
    }
    
    
    func removeCoupon(){
        couponLoading = true
        CartControllerAPI.removeVoucher { data, error in
            self.couponLoading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.cart = data
            }
        }
    }
    
    
    func pendingApprovalRequest(request:PendingApprovalRequest){
        loading = true
        CartControllerAPI.pendingApprovalRequest(request: request) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.pendingApproval = data
            }
        }
    }
    
    
    func orderAddress(cartId:String , addressId:String , friendFlag:String) {
        
        loading = true
        CartControllerAPI.orderAddress(cartId: cartId, addressId: addressId, friendFlag: friendFlag){ data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.orderAddress = data
            }
        }
        
    }
    
    
    func getTimes(){
        loading = true
        CartControllerAPI.times { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.times = data
            }
        }
    }
    
    func updateTime(cartId:String, time:String){
        loading = true
        CartControllerAPI.updateTime(cartId: cartId, time: time) { data, error in
            if let error = error {
                self.error = error
                self.loading = false
            }else if let data = data {
                self.timeUpdated = data
            }
        }
    }
    
    func cartToOrder(cartId: String, applePayTokenData: String? = nil) {
        self.proceedLoading = true
        if let applePayTokenData = applePayTokenData {
            convertCartToOrder(cartId: cartId)
                .flatMap { [unowned self] res -> AnyPublisher<AppResponse?, Error> in
                    let orderIDs = res?.orders?.compactMap { $0.id }.joined(separator: "|") ?? ""
                    return self.applePay(cartId: cartId, clientIp: getIPAddress(), applepaydata: applePayTokenData, orderID: orderIDs)
                }.receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [unowned self] completion in
                    self.proceedLoading = false
                    if case .failure(let err) = completion {
                        self.error = err
                    }
                }, receiveValue: { [unowned self] res in
                    self.applePay = res
                })
                .store(in: &cancellables)
        } else {
            convertCartToOrder(cartId: cartId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [unowned self] completion in
                    self.proceedLoading = false
                    if case .failure(let err) = completion {
                        self.error = err
                    }
                }, receiveValue: { [unowned self] res in
                    self.cartOrder = res
                })
                .store(in: &cancellables)
        }
    }
       
       private func convertCartToOrder(cartId: String) -> AnyPublisher<Orders?, Error> {
           return Future { promise in
               CartControllerAPI.convertCartToOrder(cartId: cartId) { data, error in
                   if let error = error {
                       promise(.failure(error))
                   } else {
                       promise(.success(data))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
       
       private func applePay(cartId: String, clientIp: String, applepaydata: String, orderID: String) -> AnyPublisher<AppResponse?, Error> {
           return Future { promise in
               CartControllerAPI.applePay(cartId: cartId, clientIp: clientIp, applepaydata: applepaydata, orderID: orderID) { data, error in
                   if let error = error {
                       promise(.failure(error))
                   } else {
                       promise(.success(data))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
    
    
    private func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
}
