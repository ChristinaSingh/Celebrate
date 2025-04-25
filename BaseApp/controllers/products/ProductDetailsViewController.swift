//
//  ProductDetailsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit
import Combine

class ProductDetailsViewController: UIViewController {
    
    fileprivate var cellHeights: [Int: [Int: CGFloat]] = [:]
    private let product:Product
    private var productDetails:ProductDetails?{
        didSet{
            if self.cartItem == nil && self.cartType != .popups {
                self.hideShowActions(productDetails: productDetails)
            }
            self.calcTotal(productDetails: productDetails)
        }
    }
    private let cartType:CartType
    private var cartBody:CartBody?
    private var productTimeSlots: DeliveryTimes?
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let productViewModel:ProductsViewModel
    private let cartViewModel:CartViewModel
    private var types:[ProductOption]
    private let cartItem:CartItem?
    private let cartId:String?
    private let popupLocationID: String?
    private let popupLocationDate: PopupLocationDate?
    private let date:String?
    private let locationId:String?
    private let giftAddressId:String?
    private let friendId:String?
    private let giftDate:String?
    private let cartTime:String?
    
    var callback:((Cart?) -> ())?
    init(product: Product? = nil, date:String? = nil, locationId:String? = nil ,cartItem:CartItem? = nil, cartId:String? = nil, cartType:CartType = .normal, popupLocationID: String? = nil, popupLocationDate: PopupLocationDate? = nil, giftAddressId:String? = nil, giftDate:String? = nil, cartTime:String? = nil, friendId:String? = nil) {
        self.product = product ?? Product()
        self.date = date
        self.locationId = locationId
        self.cartItem = cartItem
        self.productDetails = nil
        self.cartId = cartId
        self.types = []
        self.cartBody = nil
        self.cartType = cartType
        self.popupLocationID = popupLocationID
        self.popupLocationDate = popupLocationDate
        self.giftDate = giftDate
        self.giftAddressId = giftAddressId
        self.cartTime = cartTime
        self.friendId = friendId
        self.productViewModel = ProductsViewModel()
        self.cartViewModel = CartViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let addToCartCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    private let addToCartBtn:AddToCartButton = {
        let btn = AddToCartButton()
        return btn
    }()
    
    private lazy var loadingBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "" , width: self.view.frame.width - CGFloat(84), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    private let favoriteBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "heart_details"), for: .normal)
        btn.setImage(UIImage(named: "heart_details_selected"), for: .selected)
        return btn
    }()
    
    private lazy var  tableView:ContentFittingTableView = {
        let table = ContentFittingTableView(frame: .zero, style: .grouped)
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
        table.register(ProductDetailsBannerCell.self, forCellReuseIdentifier: "ProductDetailsBannerCell")
        table.register(ProductDetailsDeliveryTimeCell.self, forCellReuseIdentifier: "ProductDetailsDeliveryTimeCell")
        table.register(ProductDetailsTitleCell.self, forCellReuseIdentifier: "ProductDetailsTitleCell")
        table.register(ProductDetailsDescriptionCell.self, forCellReuseIdentifier: "ProductDetailsDescriptionCell")
        table.register(ProductDetailsCancellationCell.self, forCellReuseIdentifier: "ProductDetailsCancellationCell")
        table.register(ProductDetailsSSSQCell.self, forCellReuseIdentifier: "ProductDetailsSSSQCell")
        table.register(ProductDetailsSSMQCell.self, forCellReuseIdentifier: "ProductDetailsSSMQCell")
        table.register(ProductDetailsMSSQCell.self, forCellReuseIdentifier: "ProductDetailsMSSQCell")
        table.register(ProductDetailsMSMQCell.self, forCellReuseIdentifier: "ProductDetailsMSMQCell")
        table.register(ProductDetailsYESNOCell.self, forCellReuseIdentifier: "ProductDetailsYESNOCell")
        table.register(ProductDetailsINPUTCell.self, forCellReuseIdentifier: "ProductDetailsINPUTCell")
        table.register(ProductDetailsSectionHeader.self, forHeaderFooterViewReuseIdentifier: "ProductDetailsSectionHeader")
        return table
    }()
    
    private let shimmerView: ShimmerView = {
        let view = ShimmerView(nibName: "ProductDetails")
        return view
    }()
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actions()
        observers()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView , tableView , addToCartCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        addToCartCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        [favoriteBtn ,loadingBtn ,addToCartBtn].forEach { view in
            self.addToCartCardView.addSubview(view)
        }
        
        favoriteBtn.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }
        loadingBtn.isHidden = true
        loadingBtn.snp.makeConstraints { make in
            make.leading.equalTo(self.favoriteBtn.snp.trailing).offset(16)
            make.centerY.equalTo(self.favoriteBtn.snp.centerY)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        addToCartBtn.snp.makeConstraints { make in
            make.leading.equalTo(self.favoriteBtn.snp.trailing).offset(16)
            make.centerY.equalTo(self.favoriteBtn.snp.centerY)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.addToCartCardView.snp.top)
            make.top.equalTo(self.headerView.snp.bottom)
        }
        self.addToCartBtn.isUpdated = self.cartItem != nil
        
        if let popupLocationDate = popupLocationDate?.date, let locationId = popupLocationID {
            productViewModel.getDetails(productId: self.product.id, userId: User.load()?.details?.id ?? "", date: popupLocationDate, locationId: locationId)
        }else if let giftDate = giftDate {
            productViewModel.getDetails(productId: self.product.id, userId: User.load()?.details?.id ?? "", date: giftDate , locationId: self.locationId)
        }else {
            productViewModel.getDetails(productId: self.product.id, userId: User.load()?.details?.id ?? "", date: self.date , locationId: self.locationId)
        }
    }
    
    
    private func observers(){
        
        cartViewModel.$cartDeleted.receive(on: DispatchQueue.main).sink { deletedCart in
            if let _ = deletedCart {
                guard let body = self.cartBody else{return}
                self.cartViewModel.addItemToCart(item: body, cartType: self.cartType, popupLocationID: self.popupLocationID, popupLocationDate: self.popupLocationDate)
            }
        }.store(in: &cancellables)
        
        cartViewModel.$expiredCart.receive(on: DispatchQueue.main).sink { expiredCart in
            if let expiredCart = expiredCart {
                self.cartExpired(cart: expiredCart)
            }
        }.store(in: &cancellables)
        
        productViewModel.$removeFromWishListloading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        
        productViewModel.$productRemovedFromWishList.dropFirst().receive(on: DispatchQueue.main).sink { productRemovedFromWishList in
            if let _ = productRemovedFromWishList {
                self.favoriteBtn.isSelected = false
                MainHelper.showToastMessage(message: "Product removed successfully from wishlist".localized, style: .success, position: .Bottom)
            }
        }.store(in: &cancellables)
        
        productViewModel.$loading
            .combineLatest(cartViewModel.$loading)
            .receive(on: DispatchQueue.main)
            .sink { productLoading, cartLoading in
                [self.headerView , self.tableView].forEach{ $0.isUserInteractionEnabled = !cartLoading }
                if productLoading {
                    self.addToCartBtn.isHidden = true
                    self.loadingBtn.isHidden = true
                    self.addToCartCardView.isHidden = true
                    self.shimmerView.showShimmer(vc: self)
                }else if cartLoading{
                    self.addToCartBtn.isHidden = true
                    self.loadingBtn.isHidden = false
                    self.addToCartCardView.isHidden = false
                    self.loadingBtn.loading(true){
//                        self.addToCartBtn.isHidden = false
//                        self.loadingBtn.isHidden = true
                    }
                    self.shimmerView.hideShimmer(vc: self)
                }else{
                    self.addToCartBtn.isHidden = false
                    self.loadingBtn.isHidden = true
                    self.addToCartCardView.isHidden = false
                    self.shimmerView.hideShimmer(vc: self)
                }
            }
            .store(in: &cancellables)
        
        
        productViewModel.$error
            .combineLatest(cartViewModel.$error)
            .receive(on: DispatchQueue.main)
            .sink {  productError, cartError in
                if let error = productError ?? cartError {
                    if let error = error as? CartError {
                        let vc = RecreateCartViewController(cartViewModel: self.cartViewModel, error: error)
                        SheetPresenter.shared.presentSheet(vc, on: self, height: 300, isCancellable: false)
                    }else{
                        MainHelper.handleApiError(error)
                    }
                }else{
                    MainHelper.handleApiError(productError ?? cartError)
                }
            }
            .store(in: &cancellables)
        
        self.productViewModel.$productTimeSlots.receive(on: DispatchQueue.main).sink { timeSlots in
            self.productTimeSlots = timeSlots
        }.store(in: &cancellables)
        
        self.productViewModel.$productDetails.receive(on: DispatchQueue.main).sink { productDetails in
            self.productDetails = productDetails
            self.favoriteBtn.isSelected = productDetails?.isFav == 1
            self.headerView.titleLbl.text = self.productDetails?.vendor?.name
            self.productDetails?.requiresApproval = self.product.requiresApproval == true
            if let cartItem = self.cartItem {
                self.setProductSelections(item: cartItem, product: self.productDetails ?? ProductDetails())
            }
            self.fillTypes()
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        
        self.cartViewModel.$addedItemToCart.receive(on: DispatchQueue.main).sink { item in
            guard let _ = item else {return}
            if self.cartType == .ai || self.cartType == .gift || self.cartType == .popups{
//                let vc = CartViewController()
//                vc.isModalInPresentation = true
//                self.present(vc, animated: true)
                self.tabBarController?.selectedIndex = 2

                self.dismiss(animated: true) {
                    self.callback?(item)
                }

            }else {
                self.dismiss(animated: true) {
                    self.callback?(item)
                }
            }
        }.store(in: &cancellables)
    }
    
    
    private func setProductSelections(item:CartItem, product:ProductDetails){
        for (index , _) in (product.options ?? []).enumerated() {
            for option in item.productOption ?? [] {
                switch ProductOption.type(type: option.type ?? "") {
                case .MSMQ , .MSSQ , .SSSQ , .SSMQ:
                    if product.options?[index].id == option.id {
                        for selectedValue in option.value ?? [] {
                            for (mIndex , productOpion) in (product.options?[index].config?.res ?? []).enumerated() {
                                if selectedValue.valueID?.string == productOpion.id {
                                    product.options?[index].config?.res?[mIndex].checked = true
                                    if selectedValue.qty?.integer != -1 {
                                        product.options?[index].config?.res?[mIndex].qty = selectedValue.qty?.integer ?? 0
                                    }else {
                                        product.options?[index].config?.res?[mIndex].qty = Int(selectedValue.qty?.string ?? "0") ?? 0
                                    }
                                    
                                }
                            }
                        }
                    }
                    break
                case .INPUT:
                    if product.options?[index].id == option.id {
                        if option.value?.count ?? 0 > 0 {
                            product.options?[index].inputText = option.value?[0].value ?? ""
                        }
                    }
                    break
                case .YESNO:
                    if product.options?[index].id == option.id {
                        if option.value?.count ?? 0 > 0 {
                            product.options?[index].isSelected = option.value?[0].qty?.integer == 1
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
        self.productDetails = product
    }
    
    private func cartExpired(cart:Cart){
        let vc = ExpiredViewController(titleStr: "Cart has been expired".localized, message: "Your cart has been expired and it's products will be deleted, By proceeding we will create new cart.".localized) {
            self.cartViewModel.deleteCart(id: cart.id ?? "")
        }
        SheetPresenter.shared.presentSheet(vc, on: self, height: 234, isCancellable: false)
    }
    
    private func actions(){
        
        favoriteBtn.tap {
            if self.favoriteBtn.isSelected {
                self.productViewModel.removeProductFromWishList(productId: self.product.id ?? "")
            }else{
                let vc = ProductWishListTypesViewController(product: self.product)
                vc.isModalInPresentation = true
                vc.callback = { [weak self] isAdded in
                    self?.favoriteBtn.isSelected = isAdded
                }
                self.present(vc, animated: true)
            }
        }
        
        addToCartBtn.tap = { [self] in
            guard let product = self.productDetails else {
                //TODO:- show invlaid product toast
                return
            }
            let tuple = ProductHandler.isvalidSelections(product: product)
            if let section = tuple.section {
                self.tableView.performBatchUpdates({
                    self.scrollToSection(section + self.getTopSectionsCount())
                })
                ToastBanner.shared.show(message: tuple.message ?? "", style: .info, position: .Top)
                return
            }
            if let productDetails = self.productDetails {
                if let cartItem = self.cartItem {
                    self.cartViewModel.loading = true
                    CartControllerAPI.deleteItemFromCart(id: cartItem.groupHash ?? "", cartId: self.cartId ?? ""){ [self] data, error in
                        if let _ = data {
                            self.cartBody = ProductHandler.createCartBody(product: productDetails, date: self.date, location: self.locationId, selections: tuple.selections, addressid: self.giftAddressId, cartTime: self.cartTime ?? "", friendID: friendId)
                            guard let body = self.cartBody else{return}
                            self.cartViewModel.addItemToCart(item: body, cartType: self.cartType, popupLocationID: self.popupLocationID, popupLocationDate: self.popupLocationDate)
                        }else if let error = error {
                            self.cartViewModel.loading = false
                            MainHelper.handleApiError(error)
                        }else{
                            self.cartViewModel.loading = false
                        }
                    }
                }else{
                    if let popupLocationDate = self.popupLocationDate {
                        self.cartBody = ProductHandler.createCartBody(product: productDetails, date: popupLocationDate.date, location: self.popupLocationID , selections: tuple.selections, addressid: self.giftAddressId, cartTime: popupLocationDate.time, friendID: friendId)
                        guard let body = self.cartBody else{return}
                        self.cartViewModel.addItemToCart(item: body, cartType: self.cartType, popupLocationID: self.popupLocationID, popupLocationDate: self.popupLocationDate)
                        
                    }else {
                        self.cartBody = ProductHandler.createCartBody(product: productDetails, date: self.giftDate == nil ? self.date : self.giftDate, location: self.locationId, selections: tuple.selections, addressid: self.giftAddressId, cartTime: self.cartType == .normal ? OcassionDate.shared.getTime() : self.cartTime, friendID: self.friendId)
                        guard let body = self.cartBody else{return}
                        self.cartViewModel.addItemToCart(item: body, cartType: self.cartType, popupLocationID: self.popupLocationID, popupLocationDate: self.popupLocationDate)
                    }
                }
            }
            
            ExploreViewController.shared.setupCartCount()
        }
    }
    
    private func scrollToSection(_ section:Int){
        let headerRect = tableView.rectForHeader(inSection: section)
        tableView.scrollRectToVisible(headerRect, animated: true)
    }
    
    private func fillTypes(){
        guard let productDetails = productDetails else {
            return
        }
        self.types.removeAll()
        if let _ = productDetails.extraImages {
            self.types.append(.BANNER)
        }
        
        if let _ = productDetails.name {
            self.types.append(.TITLE)
        }
        
        if let _ = productDetails.productDescription {
            self.types.append(.DESCRIPTION)
        }
        
        if let _ = productDetails.cancellationPolicy {
            self.types.append(.CANCELLATION)
        }
        
//        if let slots = productTimeSlots , slots.slots?.isEmpty == false{
//            self.types.append(.DELIVERY)
//        }
        
        if let options = productDetails.options {
            for option in options {
                self.types.append(ProductOption.type(type: option.type ?? ""))
            }
        }
    }
    
    private func calcTotal(productDetails:ProductDetails?){
        let tuple = ProductHandler.calcTotal(productDetails: productDetails)
        if tuple.isSelected == true {
            self.addToCartBtn.price = tuple.total
        }else{
            self.addToCartBtn.price = nil
        }
    }
    
    private func hideShowActions(productDetails:ProductDetails?){
        guard let productDetails = productDetails else {return}
        if productDetails.prepTimeNotAvailable == true {
            self.addToCartBtn.requiresMoreTime = true
        }else if productDetails.isLocationAvailable == false{
            self.addToCartBtn.locationNotAvailable = true
        }else if productDetails.isResourceAvailable == false{
            self.addToCartBtn.fullybooked = true
        }
    }
    
}
extension ProductDetailsViewController:UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.get(at: section)?.numberOfRows(productDetails: self.productDetails, section: section - getTopSectionsCount()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.types.get(at: indexPath.section)?.cellForRow(productDetails: self.productDetails, timeSlots: self.productTimeSlots, tableView: tableView, indexPath: indexPath, topSectionsCount: getTopSectionsCount(), delegate: self){
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.types.get(at: indexPath.section)?.height(timeSlots: self.productTimeSlots) ?? 0
    }
    
    private func getTopSectionsCount() -> Int{
        return self.types.filter { type in
            type == .BANNER || type == .TITLE || type == .DESCRIPTION || type == .CANCELLATION || type == .DELIVERY
        }.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.types.get(at: indexPath.section)?.tableView(tableView, productDetails: &self.productDetails, didSelectRowAt: indexPath, section: indexPath.section - getTopSectionsCount())
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.types.get(at: section)?.tableView(tableView, productDetails: self.productDetails, viewForHeaderInSection: section, section: section - getTopSectionsCount()){ productDetails in
            self.productDetails = productDetails
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.types.get(at: section)?.tableView(tableView, productDetails: productDetails, heightForHeaderInSection: section - getTopSectionsCount()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.types.get(at: section)?.tableView(tableView, heightForFooterInSection: section) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dict = cellHeights[indexPath.section] {
            if dict.keys.contains(indexPath.row) {
                return dict[indexPath.row]!
            } else {
                cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
                return UITableView.automaticDimension
            }
        }
        
        cellHeights[indexPath.section] = [:]
        cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
        return cellHeights[indexPath.section]![indexPath.row]!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dict = cellHeights[indexPath.section], dict[indexPath.row] == UITableView.automaticDimension {
            cellHeights[indexPath.section]![indexPath.row] = cell.bounds.height
        }
    }
    
}

extension ProductDetailsViewController:ProductOptionDelegate{
    
    func timesType(timeType: TimeSlotType, section: Int) {
        self.productTimeSlots?.timeType = timeType
    }
    
    func quantityChanged(count: Int, section: Int, tvSection: Int, row: Int) {
        self.productDetails?.options?[safe: section]?.config?.res?[safe: row]?.qty = count
        self.reloadSection(section: tvSection)
        self.calcTotal(productDetails: self.productDetails)
    }
    
    func textChanged(text: String, section: Int, tvSection: Int, row: Int) {
        self.productDetails?.options?[safe: section]?.inputText = text
        self.reloadSection(section: tvSection)
    }
    
    func select(qty: Int, section: Int, tvSection: Int, item: Int) {
        self.productDetails?.options?[safe: section]?.config?.res?[safe: item]?.qty = qty
        self.reloadSection(section: tvSection)
        self.calcTotal(productDetails: self.productDetails)
    }
    
    private func reloadSection(section:Int){
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
}
