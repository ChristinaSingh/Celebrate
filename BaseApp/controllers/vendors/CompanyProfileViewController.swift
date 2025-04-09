//
//  CompanyProfileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit
import SnapKit
import Combine

class CompanyProfileViewController: UIViewController {
    private let instance:ViewCartFloatingView = ViewCartFloatingView.newInstance()
    let viewModel:CompaniesViewModel = CompaniesViewModel()
    var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let vendor:Vendor
    private var topPicks : NewArrivals?
    var parameters:ProductsParameters?
    var subcategories : SubCategories?
    var hasMore:Bool = true
    private var header:VendorProductsHeaderView? = nil
    private var prices:PriceFilter? = nil
    init(vendor: Vendor) {
        self.vendor = vendor
        self.parameters = ProductsParameters(eventDate: OcassionDate.shared.getDate() ,pageindex: "1" , pagesize: "10" ,vendorID: vendor.id ?? "" , locationID:OcassionLocation.shared.getAreaId() , customerID: "")
        self.popupLocationDate = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    private let popupLocationDate: PopupLocationDate?
    init(vendor: Vendor,  popupLocationDate: PopupLocationDate?) {
        self.popupLocationDate = popupLocationDate
        self.vendor = vendor
        self.parameters = ProductsParameters(eventDate: OcassionDate.shared.getDate() ,pageindex: "1" , pagesize: "10" ,vendorID: vendor.id ?? "" , locationID:OcassionLocation.shared.getAreaId() , customerID: "")
        super.init(nibName: nil, bundle: nil)
    }
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let searchViewBackBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    private let searchIcon:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "search_icon_black"), for: .normal)
        return btn
    }()
    
    
    private let searchView:CardView = {
        let card = CardView()
        card.backgroundColor = .white
        card.cornerRadius = 24
        card.shadowOffsetHeight = 0
        card.shadowOffsetWidth = 0
        card.shadowColor = .clear
        card.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        card.layer.borderWidth = 1
        return card
    }()
    
    
    private let searchLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.text = "Search from over 100+ companies".localized
        return lbl
    }()
    
    
    private let searchViewIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        return icon
    }()
    
    
    private let searchBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(VendorProfileCell.self, forCellWithReuseIdentifier: "VendorProfileCell")
        collectionView.register(VendorTopPicksCell.self, forCellWithReuseIdentifier: "VendorTopPicksCell")
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell" )
        collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: "LoadingFooter")
        collectionView.register(VendorProductsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "VendorProductsHeaderView")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    let shimmerView: ShimmerView = {
        let view = ShimmerView(nibName: "VendorProfile")
        return view
    }()
    
    @MainActor lazy var selectedSubCategoryshimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "ShopByCategorySubCat")
        return view
    }()
    
    var types:[VendorProfileType] = []
    var products:Products?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observers()
        setup()
        actions()
    }
    
    
    func setup(){
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        backBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        backBtn.tintColor = .black
        self.searchViewBackBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        self.searchViewBackBtn.tintColor = .black
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView , collectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(118)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        if AppLanguage.isArabic() {
            self.titleLbl.text = vendor.nameAr
        }else{
            self.titleLbl.text = vendor.name
        }
        [titleView , searchView].forEach { view in
            self.headerView.addSubview(view)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        [backBtn , titleLbl , searchIcon].forEach { view in
            self.titleView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(self.titleLbl.snp.centerY)
        }
        
        
        
        [searchLbl , searchViewIcon , searchBtn , searchViewBackBtn].forEach { view in
            self.searchView.addSubview(view)
        }
        
        searchViewBackBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        searchLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.searchViewBackBtn.snp.trailing).offset(16)
        }
        
        searchViewIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBtn.tap {
            self.openSearch()
        }
        
        searchIcon.tap {
            self.openSearch()
        }
        
        showTitleView()
        instance.setup(on: self, for: collectionView)
        viewModel.loadProfile(parameters: self.parameters)
    }
    
    private func openSearch(){
        let vc = SearchViewController()
        vc.isModalInPresentation = true
        vc.vendor = self.vendor
        self.present(vc, animated: true)
    }
    
    private func showSearchView(){
        UIView.animate(withDuration: 0.3) {
            self.titleView.isHidden = true
            self.searchView.isHidden = false
            self.containerView.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
            //self.dropSubCategoriesViewShadow()
        }
    }
    
    
    private func dropSubCategoriesViewShadow(){
        if self.types.firstIndex(where: { type in
            type == .Products
        }) != nil {
            //self.header?.dropShadow()
        }
    }
    
    private func showTitleView(){
        UIView.animate(withDuration: 0.3) {
            self.titleView.isHidden = false
            self.searchView.isHidden = true
            self.containerView.backgroundColor = .white
           // self.removeSubCategoriesViewShadow()
        }
    }
    
    
    private func removeSubCategoriesViewShadow(){
        if self.types.firstIndex(where: { type in
            type == .Products
        }) != nil  {
            //self.header?.removeShadow()
        }
    }
    
    private func actions(){
        self.backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.searchViewBackBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func observers(){
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.shimmerView.showShimmer(vc: self)
            }else{
                self.shimmerView.hideShimmer(vc: self)
            }
        }.store(in: &cancellables)
        
        viewModel.$topPicks.receive(on: DispatchQueue.main).sink { picks in
            if let topPicks = picks, topPicks.products.isEmpty == false{
                self.topPicks = topPicks
                self.types.append(.TopPicks)
                self.reloadTable()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$products.receive(on: DispatchQueue.main).sink { products in
            if let products = products {
                if let pagesize = self.parameters?.pageindex?.toInt() , let pagecount = products.pagecount {
                    self.hasMore = (pagesize + 1) <= pagecount
                }else{
                    self.hasMore = false
                }
                self.types.removeAll { type in
                    type == .Products
                }
                self.products = products
                self.types.append(.Products)
                self.reloadTable()
            }
        }.store(in: &cancellables)
        
        viewModel.$subproducts.receive(on: DispatchQueue.main).sink { products in
            if let products = products {
                if let pagesize = self.parameters?.pageindex?.toInt() , let pagecount = products.pagecount {
                    self.hasMore = (pagesize + 1) <= pagecount
                }else{
                    self.hasMore = false
                }
                self.products = products
                if let section = self.types.firstIndex(where: { type in
                    type == .Products
                }){
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadSections(IndexSet(integer: section))
                    }
                }
                
            }
        }.store(in: &cancellables)
        
        viewModel.$productsLoading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showSelectedSubCategoryShimmer()
            }else{
                self.hideSelectedSubCategoryShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$subCategories.receive(on: DispatchQueue.main).sink { subcategories in
            if let subcategories = subcategories {
                self.subcategories = subcategories
                if self.subcategories?.subcategories?.isEmpty == false{
                    self.subcategories?.subcategories?.insert(Category(id: "", name: "All products", arName: "كل المنتجات", productType: "", mediaID: "", imageURL: "" , isSelected: true), at: 0)
                }
                self.reloadTable()
            }
        }.store(in: &cancellables)
        
        
        
        viewModel.$moreProducts.receive(on: DispatchQueue.main).sink { response in
            if let products = response?.products {
                if let pagesize = self.parameters?.pageindex?.toInt() , let pagecount = response?.pagecount {
                    self.hasMore = (pagesize + 1) <= pagecount
                }else{
                    self.hasMore = false
                }
                if let section = self.types.firstIndex(where: { type in
                    type == .Products
                }){
                    self.collectionView.performBatchUpdates({
                        let startIndex = self.products?.products?.count ?? 0
                        let indexPaths = (startIndex..<startIndex + products.count).map { IndexPath(item: $0, section: section) }
                        self.products?.products?.append(contentsOf: products)
                        self.collectionView.insertItems(at: indexPaths)
                        
                    }, completion: nil)
                }
            }
        }.store(in: &cancellables)
    }
    
    private func sortTypes(){
        self.types = types.sorted { $0.rawValue < $1.rawValue }
    }
    
    func reloadTable(){
        self.types.removeAll { type in
            type == .Vendor
        }
        self.types.append(.Vendor)
        self.sortTypes()
        self.collectionView.reloadData()
    }

    
    func loadMore(){
        self.parameters?.pageindex = ((self.parameters?.pageindex?.toInt() ?? 0) + 1).toString()
        loadProducts(isLoadMore: true)
    }
    
    func showSelectedSubCategoryShimmer(){
        self.view.addSubview(selectedSubCategoryshimmerView)
        var y:CGFloat = 0
        if self.types.firstIndex(where: { type in
            type == .Products
        }) != nil{
            if let cell = header {
                y = getCellYPosition(cell: cell) + 50
            }
        }
        selectedSubCategoryshimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(y)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.selectedSubCategoryshimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    func getCellYPosition(cell: UICollectionReusableView) -> CGFloat {
        let cellFrameInSuperview = collectionView.convert(cell.frame, to: collectionView.superview)
        return cellFrameInSuperview.origin.y
    }
    
    
    func hideSelectedSubCategoryShimmer(){
        selectedSubCategoryshimmerView.removeFromSuperview()
    }
    
    private func resetLoadedProducts(){
        self.parameters?.pageindex = "1"
        self.hasMore = true
    }
    
    
    func loadProducts(isLoadMore: Bool = false){
        self.parameters?.pricefrom = self.prices?.type.rowValue().from
        self.parameters?.priceto = self.prices?.type.rowValue().to
        self.viewModel.vendorProducts(body: self.parameters, loadMore: isLoadMore)
    }

}
extension CompanyProfileViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch types.get(at: section){
        case .Vendor , .TopPicks:
            return 1
        case .Products:
            return self.products?.products?.count ?? 0
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch types.get(at: indexPath.section) {
        case .Vendor:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorProfileCell", for: indexPath) as! VendorProfileCell
            cell.vendor = self.vendor
            return cell
        case .TopPicks:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorTopPicksCell", for: indexPath) as! VendorTopPicksCell
            cell.withoutBackground = true
            cell.show(products: topPicks?.products ?? [])
            cell.callback = { product in
                let vc = ProductDetailsViewController(product: product, locationId: self.popupLocationDate?.cityId, cartType:  self.popupLocationDate != nil ? .popups : .normal, popupLocationID: self.popupLocationDate?.cityId, popupLocationDate: self.popupLocationDate)
                vc.isModalInPresentation = true
                vc.callback = { cartItem in
                    self.instance.setAmount(amount: "\(cartItem?.items?.count ?? 0) items | KD \(cartItem?.cartTotal ?? 0)")
                    self.instance.attach()
                }
                self.present(vc, animated: true, completion: nil)
            }
            return cell
        case .Products:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            cell.product = products?.products?.get(at: indexPath.row)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "VendorProductsHeaderView", for: indexPath) as! VendorProductsHeaderView
            header.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
            header.layer.cornerRadius = 8
            header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            header.containerView.layer.cornerRadius = 8
            header.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.header = header
            header.isFilterApplied = self.prices != nil
            header.clearDidTapped = {
                self.prices = nil
                header.isFilterApplied = false
                self.resetLoadedProducts()
                self.loadProducts()
            }
            header.show(categories: subcategories?.subcategories ?? [])
            header.subCategoryDidSelect = { category in
                for (index , _) in (self.subcategories?.subcategories ?? []).enumerated() {
                    self.subcategories?.subcategories?[index].isSelected = false
                }
                if let index = self.subcategories?.subcategories?.firstIndex(where: { cat in
                    cat == category
                }) {
                    self.subcategories?.subcategories?[index].isSelected = true
                }
                self.parameters?.subcategoryID = category?.id
                self.resetLoadedProducts()
                self.loadProducts()
            }
            header.filterDidTapped = {
                let vc = FilterViewController(categoryId: "", productType: "", delegate: self, prices: self.prices, stores: nil)
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
            return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingFooter", for: indexPath) as! LoadingFooter
            return footer
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch types.get(at: section) {
        case .Products:
            return CGSize(width: collectionView.frame.width, height: 64)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch types.get(at: section) {
        case .Products:
            return CGSize(width: collectionView.frame.width, height: 50)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if hasMore {
                (view as? LoadingFooter)?.loadingIndicator.startAnimating()
            }else{
                (view as? LoadingFooter)?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            (view as? LoadingFooter)?.loadingIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch types.get(at: indexPath.section) {
        case .Vendor:
            return CGSize(width: collectionView.frame.width, height: 170)
        case .TopPicks:
            return CGSize(width: collectionView.frame.width, height: 350.constraintMultiplierTargetValue.relativeToIphone8Height())
        case .Products:
            return CGSize(width: (collectionView.frame.width - 24) / 2, height: 289.constraintMultiplierTargetValue.relativeToIphone8Height())
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch types.get(at: section) {
        case .Products:
            return 8
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch types.get(at: section) {
        case .Products:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch types.get(at: section) {
        case .Products:
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.item == 0 {
            showTitleView()
        }
        if let productsection = self.types.firstIndex(where: { type in
            type == .Products
        }){
            if indexPath.section == productsection && indexPath.item == (self.products?.products?.count ?? -1) - 4 && !self.viewModel.loadMore && hasMore{
                self.loadMore()
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.item == 0 {
            showSearchView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch types.get(at: indexPath.section) {
        case .Products:
            if let product = products?.products?.get(at: indexPath.row) {
                let vc = ProductDetailsViewController(product: product, locationId: self.popupLocationDate?.cityId, cartType:  self.popupLocationDate != nil ? .popups : .normal, popupLocationID: self.popupLocationDate?.cityId, popupLocationDate: self.popupLocationDate)
                vc.isModalInPresentation = true
                vc.callback = { cartItem in
                    self.instance.setAmount(amount: "\(cartItem?.items?.count ?? 0) items | KD \(cartItem?.cartTotal ?? 0)")
                    self.instance.attach()
                }
                self.present(vc, animated: true)
            }
        default:
            break
        }
    }

}
extension CompanyProfileViewController:Filter{
    
    func apply(prices: PriceFilter?, stores: [Vendor]) {
        self.resetLoadedProducts()
        self.prices = prices
        self.header?.isFilterApplied = self.prices != nil
        self.loadProducts()
    }
}
