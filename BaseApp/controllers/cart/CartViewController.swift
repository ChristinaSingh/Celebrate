//
//  CartViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 22/08/2024.
//

import Foundation
import SnapKit
import UIKit
import Combine


enum CartSections {
    case Cart
    case PaymentMethod
    case BillDetails
    case Coupon
    
    func getTitle() -> String{
        return switch self {
        case .Cart:
            ""
        case .PaymentMethod:
            "Payment method".localized
        case .BillDetails:
            "Bill Details".localized
        case .Coupon:
            "Offers & Benefits".localized
        }
    }
}


enum ItemsType{
    case payonApproval
    case normal
    case mixed
}

class CartViewController: UIViewController {
 
    
    private let applePayManager:ApplePayManager
    public let cartViewModel:CartViewModel
    private let addressesViewModel:AddressesViewModel
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var sections:[CartSections]
    private var addresses:[Address]
    private var deliveryAddress:Address?
    private var carts: Carts
    private var coupon: String
    private var couponAppling: Bool
    private var totalCart:Double
    private var discount:Double
    private var totalFees:Double
    private var payment:PaymentMethod
    private var cartType:CartType = .normal{
        didSet{
            if cartType == .popups{
                self.proceedBtn.setTitle("Proceed to pay".localized)
                if self.payment == .ApplePay {
                    self.proceedBtn.isHidden = true
                    self.applePayManager.applePayBtn.isHidden = false
                }else{
                    self.proceedBtn.isHidden = false
                    self.applePayManager.applePayBtn.isHidden = true
                }
            }
        }
    }
    init() {
        self.applePayManager = ApplePayManager.shared
        self.cartViewModel = CartViewModel()
        self.addressesViewModel = AddressesViewModel()
        self.sections = []
        self.carts = []
        self.addresses = []
        self.totalCart = 0.0
        self.totalFees = 0.0
        self.deliveryAddress = nil
        self.payment = .ApplePay
        self.coupon = ""
        self.couponAppling = false
        self.discount = 0.0
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    private let headerView:UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()

//    public let headerView:HeaderView = {
//        let view = HeaderView(title: "Cart".localized)
//        view.backgroundColor = .white
////        view.cancelBtn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
//        return view
//    }()
    
    // Unhide bottomtabnav
    @objc func handleCancel(){
        print("Cancel Pressed")
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("UnhideBottomTabBar"), object: nil)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private let containerView:UIView = {
        let view = UIView()
        //view.backgroundColor = .blue
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        return view
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Cart")
        return view
    }()
    
    private lazy var  tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 50
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        table.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        table.register(BillDetailsCell.self, forCellReuseIdentifier: "BillDetailsCell")
        table.register(PaymentMethodCell.self, forCellReuseIdentifier: "PaymentMethodCell")
        table.register(CouponCell.self, forCellReuseIdentifier: "CouponCell")
        table.register(CartItemSectionHeader.self, forHeaderFooterViewReuseIdentifier: "CartItemSectionHeader")
        table.register(CartSectionHeader.self, forHeaderFooterViewReuseIdentifier: "CartSectionHeader")
        return table
    }()
    
    
    private let totalCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    

    private lazy var proceedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "",  width: 210, height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.button.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    private let toPayLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    private let totalTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .accent
        lbl.text = "Total amount".localized
        return lbl
    }()
    
    
    private let selectedAddressView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 24
        card.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner ]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    private let navigation:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "mappin.and.ellipse")
        img.tintColor = .accent
        return img
    }()
    
    
    private let addressType:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    
    private let addressLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return lbl
    }()
    
    
    private let dropdownIcon:UIImageView = {
        let img = UIImageView()
        img.image = .filterArrow
        return img
    }()
    
    
    private let reselectBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private let emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "no_addresses"), message: "Looks like you don’t have any saved address".localized, imgSize: CGSize(width: 120, height: 120))
        return view
    }()
    
    private var itemsType:ItemsType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        headerView.delegate = self
//        print("HeaderView delegate set: \(headerView.delegate != nil)")
//        self.view.backgroundColor = .white
//        self.view.addSubview(headerView)
//        self.view.addSubview(containerView)
//        emptyState.message = "Looks like you don’t have any items in your cart".localized
//        emptyState.icon = UIImage(named: "empty_wish_list")
//        applePayManager.delegate = self
//        self.applePayManager.applePayBtn.isHidden = true
//        containerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        headerView.cancel(vc: self)
//        print("HeaderView delegate set: \(headerView.delegate != nil)")
//        self.selectedAddressView.isHidden = true
//        [navigation, addressType, separatorView, addressLbl, dropdownIcon, reselectBtn].forEach { view in
//            self.selectedAddressView.addSubview(view)
//        }
//        
//        navigation.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().offset(16)
//            make.width.height.equalTo(24)
//        }
//        
//        
//        addressType.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(self.navigation.snp.trailing).offset(8)
//        }
//        
//        
//        separatorView.snp.makeConstraints { make in
//            make.width.equalTo(1)
//            make.leading.equalTo(self.addressType.snp.trailing).offset(8)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(12)
//        }
//        
//        dropdownIcon.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-16)
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(12)
//        }
//        
//        addressLbl.snp.makeConstraints { make in
//            make.leading.equalTo(self.separatorView.snp.trailing).offset(8)
//            make.trailing.equalTo(self.dropdownIcon.snp.leading).offset(-8)
//            make.centerY.equalToSuperview()
//        }
//        
//        reselectBtn.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        [headerView, selectedAddressView, tableView, totalCardView, emptyState].forEach { view in
//            self.containerView.addSubview(view)
//        }
//        
//        headerView.snp.makeConstraints { make in
//            //make.top.leading.trailing.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        
//        selectedAddressView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(self.headerView.snp.bottom)
//            make.height.equalTo(0)
//        }
//        
//        
//        totalCardView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(101)
//        }
//        
//        tableView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.top.equalTo(self.selectedAddressView.snp.bottom)
//            make.bottom.equalTo(self.totalCardView.snp.top)
//        }
//        
//        emptyState.isHidden = true
//        emptyState.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(self.view.frame.width * 0.5)
//            make.height.equalTo(200)
//            
//        }
//        
//        [toPayLbl, self.applePayManager.applePayBtn, proceedBtn, totalTitleLbl].forEach { view in
//            self.totalCardView.addSubview(view)
//        }
//        
//        toPayLbl.snp.makeConstraints { make in
//            make.leading.top.equalToSuperview().inset(16)
//        }
//        
//        applePayManager.applePayBtn.snp.makeConstraints { make in
//            make.top.trailing.equalToSuperview().inset(16)
//            make.width.equalTo(210)
//            make.height.equalTo(48)
//        }
//        
//        proceedBtn.snp.makeConstraints { make in
//            make.top.trailing.equalToSuperview().inset(16)
//            make.width.equalTo(210)
//            make.height.equalTo(48)
//        }
//        
//        totalTitleLbl.snp.makeConstraints { make in
//            make.leading.equalTo(self.toPayLbl.snp.leading)
//            make.top.equalTo(self.toPayLbl.snp.bottom).offset(4)
//        }
//        
//        reselectBtn.tap {
//            self.selectAddress()
//        }
//        
//        proceedBtn.tap = {
//            if self.deliveryAddress != nil || self.cartType == .popups || self.cartType == .gift {
//                if self.itemsType == .normal {
//                    if self.payment == .ApplePay {
//                        self.applePayManager.authorisePayment(toPayAmount: (self.totalFees + self.totalCart - self.discount), on: self)
//                    }else{
//                        self.cartViewModel.cartToOrder(cartId: self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|"))
//                    }
//                }else if self.itemsType == .mixed{
//                    let vc = PayNowOrLaterViewController()
//                    vc.isModalInPresentation = true
//                    vc.callback = { type in
//                        guard let type = type else {return}
//                        if type == .PayNow {
//                            if self.payment == .ApplePay {
//                                self.applePayManager.authorisePayment(toPayAmount: (self.totalFees + self.totalCart), on: self)
//                            }else{
//                                self.cartViewModel.cartToOrder(cartId: self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|"))
//                            }
//                        }else{
//                            self.cartViewModel.pendingApprovalRequest(request: PendingApprovalRequest(cartItemID: self.getPendingItemsCartIds(), pendingOrderApprovalStatus: 1))
//                        }
//                    }
//                    self.present(vc, animated: true)
//                }else{
//                    self.cartViewModel.pendingApprovalRequest(request: PendingApprovalRequest(cartItemID: self.getPendingItemsCartIds(), pendingOrderApprovalStatus: 1))
//                }
//                
//            }else{
//                if self.addresses.isEmpty {
//                    let vc = AddAddressViewController()
//                    vc.addressDidAdd = { address in
//                        self.setOrderAddress(address: address)
//                    }
//                    vc.locationId = self.carts.first?.location?.locationID
//                    vc.areaName = self.carts.first?.location?.locationName
//                    vc.isModalInPresentation = true
//                    self.present(vc, animated: true)
//                }else{
//                    self.selectAddress()
//                }
//            }
//        }
//        
//        cartViewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
//            if isLoading {
//                self.showShimmer()
//            }else {
//                self.hideShimmer()
//            }
//        }.store(in: &cancellables)
//        
//        cartViewModel.$timeUpdated.dropFirst().receive(on: DispatchQueue.main).sink { response in
//            if let status = response?.status, status.string.lowercased() == "success".lowercased() {
//                self.cartViewModel.fetchCarts()
//            }else{
//                MainHelper.showToastMessage(message: response?.message ?? "Something went wrong", style: .error, position: .Top)
//            }
//        }.store(in: &cancellables)
//        
//        addressesViewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
//            if isLoading {
//                self.showShimmer()
//            }else {
//                self.hideShimmer()
//            }
//        }.store(in: &cancellables)
//        
//        cartViewModel.$proceedLoading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
//            self.proceedBtn.loading(isLoading)
//        }.store(in: &cancellables)
//        
//        cartViewModel.$cart.dropFirst().receive(on: DispatchQueue.main).sink { carts in
//            guard let carts = carts, carts.isEmpty == false, carts.allSatisfy({ $0.items?.isEmpty == true }) == false else {
//                self.tableView.isHidden = true
//                self.totalCardView.isHidden = true
//                self.emptyState.isHidden = false
//                self.selectedAddressView.isHidden = true
//                self.selectedAddressView.snp.updateConstraints { make in
//                    make.height.equalTo(0)
//                }
//                return
//            }
//            
//            self.cartType = carts.first?.cartType ?? .normal
//            self.carts = carts
//            self.sections.removeAll()
//            carts.forEachIndexed({ _, _ in
//                self.sections.append(.Cart)
//            })
//            self.caclulateTotal(carts: carts)
//            self.applePayManager.initPayment(toPayAmount: (self.totalFees + self.totalCart), on: self)
//            let totalCount = carts.map { $0.items?.count ?? 0 }.reduce(0, +)
//            if (self.getWaitingForApproval().count + self.getPendingItemsCartIds().count) ==  totalCount {
//                self.itemsType = .payonApproval
//            }else if self.getPendingItemsCartIds().count == 0 {
//                self.itemsType = .normal
//            }else {
//                self.itemsType = .mixed
//            }
//            
//            if self.itemsType == .normal {
//                self.sections.append(contentsOf: [.Coupon, .PaymentMethod, .BillDetails])
//                if self.payment == .ApplePay {
//                    self.payment = .ApplePay
//                    self.proceedBtn.isHidden = true
//                    self.applePayManager.applePayBtn.isHidden = false
//                }
//            }else {
//                self.payment = .Knet
//                self.proceedBtn.isHidden = false
//                self.applePayManager.applePayBtn.isHidden = true
//                self.sections.append(contentsOf: [.Coupon, .BillDetails])
//            }
//            if self.cartType == .gift {
//                self.reselectBtn.isUserInteractionEnabled = false
//                if self.itemsType == .normal {
//                    self.proceedBtn.setTitle("Proceed to pay".localized)
//                }else{
//                    let totalCount = self.carts.map { $0.items?.count ?? 0 }.reduce(0, +)
//                    if self.getWaitingForApproval().count == totalCount {
//                        self.proceedBtn.enableDisableSaveButton(isEnable: false)
//                        self.proceedBtn.setTitle("Waiting for approval".localized)
//                    }else {
//                        self.proceedBtn.setTitle("Proceed".localized)
//                    }
//                }
//            }else{
//                self.addressesViewModel.getAddresses(locationId: carts.first?.location?.locationID ?? "")
//            }
//            self.tableView.reloadData()
//        }.store(in: &cancellables)
//        
//        addressesViewModel.$addresses.dropFirst().receive(on: DispatchQueue.main).sink { addresses in
//            print("Address viewmodel updated: \(addresses?.addresses ?? [])")
//            /*self.proceedBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
//            self.view.bringSubviewToFront(self.proceedBtn)*/
//            if self.cartType != .popups {
//                if let address = addresses?.addresses?.first(where: { address in
//                    address.id == self.carts.first?.addressID
//                }){
//                    self.updateAddress(address: address)
//                    self.reselectBtn.isUserInteractionEnabled = self.cartType != .gift
//                    if self.itemsType == .normal {
//                        self.proceedBtn.setTitle("Proceed to pay".localized)
//                    }else{
//                        let totalCount = self.carts.map { $0.items?.count ?? 0 }.reduce(0, +)
//                        if self.getWaitingForApproval().count == totalCount {
//                            self.proceedBtn.enableDisableSaveButton(isEnable: false)
//                            self.proceedBtn.setTitle("Waiting for approval".localized)
//                        }else {
//                            self.proceedBtn.setTitle("Proceed".localized)
//                        }
//                    }
//                    
//                }else{
//                    self.tabBarController?.tabBar.isHidden = true
//                    self.proceedBtn.isHidden = false
//                    self.applePayManager.applePayBtn.isHidden = true
//                    if addresses?.addresses?.isEmpty == true {
//                        self.proceedBtn.setTitle("Add address to proceed".localized)
//                        
//                        // force visibility when need be
//                        if self.proceedBtn.isHidden {
//                            print("proceedBtn was hidden, force showing")
//                            self.proceedBtn.isHidden = false
//                        }
//                    }else{
//                        self.proceedBtn.setTitle("Select address to proceed".localized)
//                    }
//                }
//            }
//           
//            self.addresses = addresses?.addresses ?? []
//        }.store(in: &cancellables)
//        
//        cartViewModel.$couponLoading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
//            if let section = self.sections.firstIndex(of: .Coupon) {
//                self.couponAppling = isLoading
//                UIView.performWithoutAnimation {
//                    self.tableView.reloadSections(IndexSet(integer: section), with: .none)
//                }
//            }
//        }.store(in: &cancellables)
//        
//        cartViewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
//            MainHelper.handleApiError(error)
//        }.store(in: &cancellables)
//        
//        cartViewModel.$applePay.dropFirst().receive(on: DispatchQueue.main).sink { res in
//            guard let status = res?.status else {return}
//            if status.string.lowercased() == "success".lowercased() {
//                let vc = PaymentSuccessViewController(orderId: ""/*to get orderId*/, orderDate: DateFormatter.formateDate(date: Date(), formate: "dd MMM, yyyy"), deliveryDate: DateFormatter.formateDate(date: OcassionDate.shared.getEventDate() ?? Date(), formate: "dd MMM, yyyy"), total: "KWD \((self.totalFees + self.totalCart))")
//                vc.isModalInPresentation = true
//                self.present(vc, animated: true)
//            }else{
//                ToastBanner.shared.show(message: res?.message ?? "Somthing went wrong", style: .error, position: .Bottom)//show fail page
//            }
//        }.store(in: &cancellables)
//        
//        cartViewModel.$orderAddress.dropFirst().receive(on: DispatchQueue.main).sink { isupdated in
//            self.cartViewModel.fetchCarts()
//        }.store(in: &cancellables)
//        
//        cartViewModel.$pendingApproval.dropFirst().receive(on: DispatchQueue.main).sink { res in
//            guard let status = res?.status else {return}
//            if status.boolean == true {
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "cart.refresh"), object: nil)
//                let vc = PaymentSuccessViewController(orderId: ""/*to get orderId*/, orderDate: DateFormatter.formateDate(date: Date(), formate: "dd MMM, yyyy"), deliveryDate: DateFormatter.formateDate(date: OcassionDate.shared.getEventDate() ?? Date(), formate: "dd MMM, yyyy"), total: "KWD \((self.totalFees + self.totalCart))", isPendingApproval: true)
//                vc.isModalInPresentation = true
//                self.present(vc, animated: true)
////                self.cartViewModel.fetchCarts()
//                
//            }else{
//                ToastBanner.shared.show(message: "Failed", style: .error, position: .Bottom)//fail pending approval
//            }
//        }.store(in: &cancellables)
//        
//        cartViewModel.$cartOrder.dropFirst().receive(on: DispatchQueue.main).sink { res in
//            guard let res = res else {return}
//            guard let url = self.generatePaymentLink(res: res) else{return}
//            let vc = WebViewController(url: url, orderId: (res.orders ?? []).map({ order in "#\(order.id ?? "")"}).joined(separator: ","), orderDate: DateFormatter.formateDate(date: Date(), formate: "dd MMM, yyyy"), deliveryDate: DateFormatter.formateDate(date: OcassionDate.shared.getEventDate() ?? Date(), formate: "dd MMM, yyyy"), total: "KWD \((self.totalFees + self.totalCart))")
//            vc.callback = {
//                let vc = ExpiredViewController(titleStr: "Payment Failed".localized, message: "We’re sorry, but your payment could not be processed at this time. Please check your payment details and try again.".localized) {}
//                SheetPresenter.shared.presentSheet(vc, on: self, height: 260, isCancellable: false)
//            }
//            vc.isModalInPresentation = true
//            self.present(vc, animated: true)
//                
//        }.store(in: &cancellables)
//        
//        cartViewModel.$cartDeleted.dropFirst().receive(on: DispatchQueue.main).sink { deletedCart in
//            if let _ = deletedCart {
//                self.carts.removeAll()
//                self.sections.removeAll()
//                self.tableView.reloadData()
//                self.tableView.isHidden = true
//                self.totalCardView.isHidden = true
//                self.emptyState.isHidden = false
//                self.selectedAddressView.isHidden = true
//                self.selectedAddressView.snp.updateConstraints { make in
//                    make.height.equalTo(0)
//                }
//            }
//        }.store(in: &cancellables)
//        
//        cartViewModel.fetchCarts()
        
        
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        emptyState.message = "Looks like you don’t have any items in your cart".localized
        emptyState.icon = UIImage(named: "empty_wish_list")
        applePayManager.delegate = self
        self.applePayManager.applePayBtn.isHidden = true
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.selectedAddressView.isHidden = true
        [navigation, addressType, separatorView, addressLbl, dropdownIcon, reselectBtn].forEach { view in
            self.selectedAddressView.addSubview(view)
        }
        
        navigation.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        
        
        addressType.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.navigation.snp.trailing).offset(8)
        }
        
        
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.leading.equalTo(self.addressType.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(12)
        }
        
        dropdownIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        addressLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.separatorView.snp.trailing).offset(8)
            make.trailing.equalTo(self.dropdownIcon.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        reselectBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [selectedAddressView, tableView, totalCardView, emptyState].forEach { view in
            self.containerView.addSubview(view)
        }
                
        selectedAddressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.height.equalTo(0)
        }
        
        
        totalCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(70)
            make.height.equalTo(101)
           // make.width.equalToSuperview()

        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.selectedAddressView.snp.bottom)
            make.bottom.equalTo(self.totalCardView.snp.top)
        }
        
        emptyState.isHidden = true
        emptyState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.5)
            make.height.equalTo(200)
            
        }
        
        [toPayLbl, self.applePayManager.applePayBtn, proceedBtn, totalTitleLbl].forEach { view in
            self.totalCardView.addSubview(view)
        }
        
        toPayLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        applePayManager.applePayBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.width.equalTo(210)
            make.height.equalTo(48)
        }
        
        proceedBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.width.equalTo(210)
            make.height.equalTo(48)
        }
        
        totalTitleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.toPayLbl.snp.leading)
            make.top.equalTo(self.toPayLbl.snp.bottom).offset(4)
        }
        
        reselectBtn.tap {
            self.selectAddress()
        }
        
        proceedBtn.tap = {
            if self.deliveryAddress != nil || self.cartType == .popups || self.cartType == .gift {
                if self.itemsType == .normal {
                    if self.payment == .ApplePay {
                        self.applePayManager.authorisePayment(toPayAmount: (self.totalFees + self.totalCart - self.discount), on: self)
                    }else{
                        self.cartViewModel.cartToOrder(cartId: self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|"))
                    }
                }else if self.itemsType == .mixed{
                    let vc = PayNowOrLaterViewController()
                    vc.isModalInPresentation = true
                    vc.callback = { type in
                        guard let type = type else {return}
                        if type == .PayNow {
                            if self.payment == .ApplePay {
                                self.applePayManager.authorisePayment(toPayAmount: (self.totalFees + self.totalCart), on: self)
                            }else{
                                self.cartViewModel.cartToOrder(cartId: self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|"))
                            }
                        }else{
                            self.cartViewModel.pendingApprovalRequest(request: PendingApprovalRequest(cartItemID: self.getPendingItemsCartIds(), pendingOrderApprovalStatus: 1))
                        }
                    }
                    self.present(vc, animated: true)
                }else{
                    self.cartViewModel.pendingApprovalRequest(request: PendingApprovalRequest(cartItemID: self.getPendingItemsCartIds(), pendingOrderApprovalStatus: 1))
                }
                
            }else{
                if self.addresses.isEmpty {
                    let vc = AddAddressViewController()
                    vc.addressDidAdd = { address in
                        self.setOrderAddress(address: address)
                    }
                    vc.locationId = self.carts.first?.location?.locationID
                    vc.areaName = self.carts.first?.location?.locationName
                    vc.isModalInPresentation = true
                    self.present(vc, animated: true)
                }else{
                    self.selectAddress()
                }
            }
        }

    }
    
    // Refresh views on switch tab
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartViewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else {
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        cartViewModel.$timeUpdated.dropFirst().receive(on: DispatchQueue.main).sink { response in
            if let status = response?.status, status.string.lowercased() == "success".lowercased() {
                self.cartViewModel.fetchCarts()
            }else{
                MainHelper.showToastMessage(message: response?.message ?? "Something went wrong", style: .error, position: .Top)
            }
        }.store(in: &cancellables)
        
        addressesViewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else {
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        cartViewModel.$proceedLoading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            self.proceedBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        cartViewModel.$cart.dropFirst().receive(on: DispatchQueue.main).sink { carts in
            guard let carts = carts, carts.isEmpty == false, carts.allSatisfy({ $0.items?.isEmpty == true }) == false else {
                self.tableView.isHidden = true
                self.totalCardView.isHidden = true
                self.emptyState.isHidden = false
                self.selectedAddressView.isHidden = true
                self.selectedAddressView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                return
            }
            
            self.cartType = carts.first?.cartType ?? .normal
            self.carts = carts
            self.sections.removeAll()
            carts.forEachIndexed({ _, _ in
                self.sections.append(.Cart)
            })
            self.caclulateTotal(carts: carts)
            self.applePayManager.initPayment(toPayAmount: (self.totalFees + self.totalCart), on: self)
            let totalCount = carts.map { $0.items?.count ?? 0 }.reduce(0, +)
            if (self.getWaitingForApproval().count + self.getPendingItemsCartIds().count) ==  totalCount {
                self.itemsType = .payonApproval
            }else if self.getPendingItemsCartIds().count == 0 {
                self.itemsType = .normal
            }else {
                self.itemsType = .mixed
            }
            
            if self.itemsType == .normal {
                self.sections.append(contentsOf: [.Coupon, .PaymentMethod, .BillDetails])
                if self.payment == .ApplePay {
                    self.payment = .ApplePay
                    self.proceedBtn.isHidden = true
                    self.applePayManager.applePayBtn.isHidden = false
                }
            }else {
                self.payment = .Knet
                self.proceedBtn.isHidden = false
                self.applePayManager.applePayBtn.isHidden = true
                self.sections.append(contentsOf: [.Coupon, .BillDetails])
            }
            if self.cartType == .gift {
                self.reselectBtn.isUserInteractionEnabled = false
                if self.itemsType == .normal {
                    self.proceedBtn.setTitle("Proceed to pay".localized)
                }else{
                    let totalCount = self.carts.map { $0.items?.count ?? 0 }.reduce(0, +)
                    if self.getWaitingForApproval().count == totalCount {
                        self.proceedBtn.enableDisableSaveButton(isEnable: false)
                        self.proceedBtn.setTitle("Waiting for approval".localized)
                    }else {
                        self.proceedBtn.setTitle("Proceed".localized)
                    }
                }
            }else{
                self.addressesViewModel.getAddresses(locationId: carts.first?.location?.locationID ?? "")
            }
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        addressesViewModel.$addresses.dropFirst().receive(on: DispatchQueue.main).sink { addresses in
            print("Address viewmodel updated: \(addresses?.addresses ?? [])")
            /*self.proceedBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
            self.view.bringSubviewToFront(self.proceedBtn)*/
            if self.cartType != .popups {
                if let address = addresses?.addresses?.first(where: { address in
                    address.id == self.carts.first?.addressID
                }){
                    self.updateAddress(address: address)
                    self.reselectBtn.isUserInteractionEnabled = self.cartType != .gift
                    if self.itemsType == .normal {
                        self.proceedBtn.setTitle("Proceed to pay".localized)
                    }else{
                        let totalCount = self.carts.map { $0.items?.count ?? 0 }.reduce(0, +)
                        if self.getWaitingForApproval().count == totalCount {
                            self.proceedBtn.enableDisableSaveButton(isEnable: false)
                            self.proceedBtn.setTitle("Waiting for approval".localized)
                        }else {
                            self.proceedBtn.setTitle("Proceed".localized)
                        }
                    }
                    
                }else{
                    self.tabBarController?.tabBar.isHidden = false
                    self.proceedBtn.isHidden = false
                    self.applePayManager.applePayBtn.isHidden = true
                    if addresses?.addresses?.isEmpty == true {
                        self.proceedBtn.setTitle("Add address to proceed".localized)
                        
                        // force visibility when need be
                        if self.proceedBtn.isHidden {
                            print("proceedBtn was hidden, force showing")
                            self.proceedBtn.isHidden = false
                        }
                    }else{
                        self.proceedBtn.setTitle("Select address to proceed".localized)
                    }
                }
            }
           
            self.addresses = addresses?.addresses ?? []
        }.store(in: &cancellables)
        
        cartViewModel.$couponLoading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if let section = self.sections.firstIndex(of: .Coupon) {
                self.couponAppling = isLoading
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(IndexSet(integer: section), with: .none)
                }
            }
        }.store(in: &cancellables)
        
        cartViewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        cartViewModel.$applePay.dropFirst().receive(on: DispatchQueue.main).sink { res in
            guard let status = res?.status else {return}
            if status.string.lowercased() == "success".lowercased() {
                let vc = PaymentSuccessViewController(orderId: ""/*to get orderId*/, orderDate: DateFormatter.formateDate(date: Date(), formate: "dd MMM, yyyy"), deliveryDate: DateFormatter.formateDate(date: OcassionDate.shared.getEventDate() ?? Date(), formate: "dd MMM, yyyy"), total: "KWD \((self.totalFees + self.totalCart))")
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }else{
                ToastBanner.shared.show(message: res?.message ?? "Somthing went wrong", style: .error, position: .Bottom)//show fail page
            }
        }.store(in: &cancellables)
        
        cartViewModel.$orderAddress.dropFirst().receive(on: DispatchQueue.main).sink { isupdated in
            self.cartViewModel.fetchCarts()
        }.store(in: &cancellables)
        
        cartViewModel.$pendingApproval.dropFirst().receive(on: DispatchQueue.main).sink { res in
            guard let status = res?.status else {return}
            if status.boolean == true {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cart.refresh"), object: nil)
                let vc = PaymentSuccessViewController(orderId: ""/*to get orderId*/, orderDate: DateFormatter.formateDate(date: Date(), formate: "dd MMM, yyyy"), deliveryDate: DateFormatter.formateDate(date: OcassionDate.shared.getEventDate() ?? Date(), formate: "dd MMM, yyyy"), total: "KWD \((self.totalFees + self.totalCart))", isPendingApproval: true)
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
//                self.cartViewModel.fetchCarts()
                
            }else{
                ToastBanner.shared.show(message: "Failed", style: .error, position: .Bottom)//fail pending approval
            }
        }.store(in: &cancellables)
        
        cartViewModel.$cartOrder.dropFirst().receive(on: DispatchQueue.main).sink { res in
            guard let res = res else {return}
            guard let url = self.generatePaymentLink(res: res) else{return}
            let vc = WebViewController(url: url, orderId: (res.orders ?? []).map({ order in "#\(order.id ?? "")"}).joined(separator: ","), orderDate: DateFormatter.formateDate(date: Date(), formate: "dd MMM, yyyy"), deliveryDate: DateFormatter.formateDate(date: OcassionDate.shared.getEventDate() ?? Date(), formate: "dd MMM, yyyy"), total: "KWD \((self.totalFees + self.totalCart))")
            vc.callback = {
                let vc = ExpiredViewController(titleStr: "Payment Failed".localized, message: "We’re sorry, but your payment could not be processed at this time. Please check your payment details and try again.".localized) {}
                SheetPresenter.shared.presentSheet(vc, on: self, height: 260, isCancellable: false)
            }
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
                
        }.store(in: &cancellables)
        
        cartViewModel.$cartDeleted.dropFirst().receive(on: DispatchQueue.main).sink { deletedCart in
            if let _ = deletedCart {
                self.carts.removeAll()
                self.sections.removeAll()
                self.tableView.reloadData()
                self.tableView.isHidden = true
                self.totalCardView.isHidden = true
                self.emptyState.isHidden = false
                self.selectedAddressView.isHidden = true
                self.selectedAddressView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
        }.store(in: &cancellables)
        
        cartViewModel.fetchCarts()
        

        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            print("Many views")
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    private func updateAddress(address: Address){
        self.deliveryAddress = address
        self.selectedAddressView.isHidden = false
        self.selectedAddressView.snp.updateConstraints { make in
            make.height.equalTo(48)
        }
        self.addressType.text = address.name
        self.addressLbl.text = "\(address.area ?? ""),\("Block".localized)-\(address.block ?? ""),\("Street".localized)-\(address.street ?? ""),\("House".localized) \(address.building ?? "")"
    }
    
    private func caclulateTotal(carts:Carts) {
        self.totalCart = 0
        self.totalFees = 0
        self.discount = 0
        for cart in carts {
            for item in cart.items ?? [] {
                if let priceStr = item.actualAmount, let price = Double(priceStr) {
                    self.totalCart += price
                }
            }
            self.totalFees += cart.deliveryFees?.total ?? 0.0
        }
        if let discountStr = carts.first?.items?.first?.discountPercent, let discount = Double(discountStr) {
            self.discount = (discount / 100) * self.totalCart
        }
        self.toPayLbl.text = "KD \((self.totalFees + self.totalCart - self.discount).clean)"
    }
    
    private func generatePaymentLink(res:Orders) -> String? {
        let ids = res.orders?.map({ order in order.id ?? ""}).joined(separator: "|") ?? ""
        let custID = User.load()?.details?.id ?? ""
        let cartID = self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|")
        return "https://admin.celebrateapp.com/pg/gotap/request?orderID=\(ids)&customerID=\(custID)&cartID=\(cartID)&paymenttype=\(self.payment.rawValue)"
    }
    
    
    
    private func selectAddress(){
        let vc = SelectAddressViewController(locationId: self.carts.first?.location?.locationID ?? "", areaName: self.carts.first?.location?.locationName ?? "")
        vc.callback = { address in
            guard let address = address else {return}
            self.setOrderAddress(address: address)
        }
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
    
    private func setOrderAddress(address:Address){
        self.updateAddress(address: address)
        if self.payment == .ApplePay {
            self.proceedBtn.isHidden = true
            self.applePayManager.applePayBtn.isHidden = false
        }else{
            self.proceedBtn.isHidden = false
            self.applePayManager.applePayBtn.isHidden = true
        }
        self.cartViewModel.orderAddress(cartId: self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|"), addressId: address.id ?? "", friendFlag: "0")
        if self.itemsType == .payonApproval {
            if self.itemsType == .normal {
                self.proceedBtn.setTitle("Proceed to pay".localized)
            }else{
                self.proceedBtn.setTitle("Proceed".localized)
            }
        }else{
            self.proceedBtn.setTitle("Proceed to pay".localized)
        }
    }
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.shimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    private func hideShimmer(){
        shimmerView.removeFromSuperview()
    }
    
    func getPendingItemsCartIds() -> [String]{
        return carts.flatMap { cart in
            cart.items?.compactMap { item in
                item.pendingItemStatus == .pending ? item.id : nil
            } ?? []
        }
    }
    
    func getWaitingForApproval() -> [String] {
        return carts.flatMap { cart in
            cart.items?.compactMap { item in
                item.pendingItemStatus == .approved_by_client ? item.id : nil
            } ?? []
        }
    }
}
extension CartViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[safe: section] {
        case .Cart:
            return self.carts[safe: section]?.items?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[safe: indexPath.section] {
        case .Cart:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell") as! CartItemCell
            cell.controller = self
            cell.cartTime = self.carts[safe: indexPath.section]?.cartTime
            let item = self.carts[safe: indexPath.section]?.items?.get(at: indexPath.row)
            cell.cartItem = item
            cell.fee = self.carts[safe: indexPath.section]?.deliveryFees?.fees?.first(where: { fee in
                fee.productID == item?.product?.id?.toInt()
            })?.fee
            cell.contextActionDidTapped = { action in
                if action == .delete {
                    cell.loadingView.isHidden = false
                    cell.moreBtn.isHidden = true
                    CartControllerAPI.deleteItemFromCart(id: item?.groupHash ?? "", cartId: self.carts[safe: indexPath.section]?.id ?? ""){ data, error in
                        cell.loadingView.isHidden = true
                        cell.moreBtn.isHidden = false
                        if let _ = data {
                            self.carts[safe: indexPath.section]?.items?.removeIfIndexExists(at: indexPath.row)
                            tableView.reloadData()
                            if self.carts[safe: indexPath.section]?.items?.isEmpty == true {
                                self.cartViewModel.deleteCart(id: self.carts[safe: indexPath.section]?.id ?? "")
                            }else{
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "cart.refresh"), object: nil)
                                self.cartViewModel.fetchCarts()
                            }
                        }
                    }
                }else{
                    let vc = ProductDetailsViewController(product: Product(id: item?.product?.id), date: self.carts[safe: indexPath.section]?.deliveryDate, locationId: self.carts[safe: indexPath.section]?.location?.locationID, cartItem: item, cartId: self.carts[safe: indexPath.section]?.id, cartType: self.carts[safe: indexPath.section]?.cartType ?? .normal, cartTime: cell.cartTime)
                    vc.callback = { [weak self] _ in
                        self?.cartViewModel.fetchCarts()
                    }
                    vc.isModalInPresentation = true
                    self.present(vc, animated: true)
                }
            }
            cell.isLastCell = indexPath.row == (self.carts[safe: indexPath.section]?.items?.count ?? 0) - 1
//            cell.configureMenu()
            return cell
        case .Coupon:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell") as! CouponCell
            cell.delegate = self
            cell.coupon = self.coupon
            cell.discount = self.discount
            cell.isLoading = self.couponAppling
            cell.couponTF.isUserInteractionEnabled = self.discount.isZero
            return cell
        case .PaymentMethod:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as! PaymentMethodCell
            cell.method = self.payment
            cell.changeBtn.tap {
                let vc = PaymentMethodViewController(isCreditCard: self.canPayWithCreditCard())
                vc.callback = { method, title in
                    guard let method = method, let title = title else {return}
                    cell.method = method
                    cell.titleLbl.text = title
                    self.payment = method
                    self.applePayManager.applePayBtn.isHidden = method != .ApplePay
                    self.proceedBtn.isHidden = method == .ApplePay
                }
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
            return cell
        case .BillDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailsCell") as! BillDetailsCell
            cell.totalLbl.text = "\(self.totalCart.clean) \("kd".localized)"
            cell.totalLbl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.deliveryFeeLbl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.toPayLbl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.discountLbl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.deliveryFeeLbl.text = "\(self.totalFees.clean) \("kd".localized)"
            cell.toPayLbl.text = "\((self.totalFees + self.totalCart - self.discount).clean) \("kd".localized)"
            cell.discountLbl.text = "\(self.discount.clean) \("kd".localized)"
            cell.discountView.isHidden = self.discount.isZero
            cell.discountView.snp.remakeConstraints { make in
                make.height.equalTo(self.discount.isZero ? 0 : 22)
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(cell.deliveryFeeLbl.snp.bottom).offset(self.discount.isZero ? 0 : 16)
            }
            return cell
        case .none:
            return UITableViewCell()
        }
       
    }
    
    private func canPayWithCreditCard() -> Bool {
        return self.carts.filter({ $0.items?.first(where: { item in
            item.vendor?.paymentmethod?.string != "2"
        }) != nil }).isEmpty
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[safe: section] {
        case .Cart:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartItemSectionHeader") as? CartItemSectionHeader
            header?.date = self.carts[safe: section]?.deliveryDate
            header?.editTimeButton.tap {
                let vc = DeliveryTimeViewController(delegate: self, time: self.carts[safe: section]?.cartTime)
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
            return header
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartSectionHeader") as? CartSectionHeader
            header?.title = sections[safe: section]?.getTitle()
            return header
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}
extension CartViewController:ApplePayManagerDelegate, CouponDelegate, DaySelectionDelegate {
    func dayDidSelected(day: Day?) {}
    
    func timeDidSelected(time: PreferredTime?) {
        guard let time = time?.displaytext, let cartId = self.carts.first?.id else { return }
        self.cartViewModel.updateTime(cartId: cartId, time: time)
    }
    
    
    
    func couponDidRemove() {
        if !self.discount.isZero {
            self.coupon = ""
            self.cartViewModel.removeCoupon()
        }
    }
    
    func couponDidChanged(_ coupon: String) {
        self.coupon = coupon
    }
    
    func couponDidApply(_ coupon: String) {
        self.cartViewModel.applyCoupon(coupon: coupon)
    }
    
    func didFinishApplePay(_ response: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.cartViewModel.cartToOrder(cartId: self.carts.map({ cart in cart.id ?? ""}).joined(separator: "|"), applePayTokenData: response)
        }
    }
    
    func didFailApplePay(_ error: String) {
        ToastBanner.shared.show(message: error, style: .error, position: .Bottom)
    }
}
