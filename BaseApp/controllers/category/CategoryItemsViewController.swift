//
//  CategoryItemsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/06/2024.
//

import UIKit
import SnapKit
import Combine

class CategoryItemsViewController: UIViewController {
    private let instance:ViewCartFloatingView = ViewCartFloatingView.newInstance()
    private var category:Category?
    private var subCategory:Category?
    private let viewModel = CategoriesViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var products:Products?
    private var subcategories : SubCategories?
    private var categories : Categories?
    private var prices:PriceFilter? = nil
    private var stores:[Vendor]? = nil
    private var header:VendorProductsHeaderView? = nil
    private var hasMore:Bool = true
    private var pageindex:Int = 1
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "ShopByCategory")
        return view
    }()
    
    
    @MainActor private lazy var selectedCategoryshimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "ShopByCategoryForCat")
        return view
    }()
    
    
    @MainActor private lazy var selectedSubCategoryshimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "ShopByCategorySubCat")
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Shop by category".localized)
        view.backgroundColor = .white
        view.withSearchBtn = true
        view.separator.isHidden = true
        return view
    }()
    
  
    
    private lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryItemCell.self, forCellWithReuseIdentifier: "CategoryItemCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let separatorView:UIView = {
        let view = UIView()
        view.alpha = 0.1
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return view
    }()
      
    private lazy var productsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell" )
        collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: "LoadingFooter")
        collectionView.register(VendorProductsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "VendorProductsHeaderView")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        headerView.back(vc: self)
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, collectionView, separatorView , productsCollectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.height.equalTo(102)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
                
        productsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.separatorView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        observers()
        viewModel.loadCategoriesAndThenLoadSubCategoriesAndThenLoadProducts(categoryId: category?.id ?? "", pageIndex: self.pageindex, pageSize: 40)
        instance.setup(on: self, for: self.productsCollectionView)
    }
    

    
    
    private func observers(){
        viewModel.$loading.receive(on: DispatchQueue.main).sink { _ in } receiveValue: { [weak self] isLoading in
            if isLoading {
                self?.showShimmer()
            }else{
                self?.hideShimmer()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$categoryLoading.receive(on: DispatchQueue.main).sink { _ in } receiveValue: { [weak self] isLoading in
            if isLoading {
                self?.showSelectedCategoryShimmer()
            }else{
                self?.hideSelectedCategoryShimmer()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$productsLoading.receive(on: DispatchQueue.main).sink { _ in } receiveValue: { [weak self] isLoading in
            if isLoading {
                self?.showSelectedSubCategoryShimmer()
            }else{
                self?.hideSelectedSubCategoryShimmer()
            }
        }.store(in: &cancellables)

        
        viewModel.$subCategories.receive(on: RunLoop.main).sink { _ in } receiveValue: { [weak self] subcategories  in
            if let subcategories = subcategories {
                self?.subcategories = subcategories
                self?.subCategory = subcategories.subcategories?.first
            }
        }.store(in: &cancellables)
        
        
        viewModel.$categories.receive(on: RunLoop.main).sink { _ in } receiveValue: { [weak self] categories  in
            if let categories = categories {
                self?.categories = categories
                if let index = self?.categories?.categories?.firstIndex(where: { cat in
                    cat.id == self?.category?.id
                }) {
                    self?.categories?.categories?[index].isSelected = true
                    self?.collectionView.reloadData()
                    self?.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$products.receive(on: DispatchQueue.main).sink { _ in } receiveValue: { [weak self] products  in
            if let products = products {
                if let pagecount = products.pagecount {
                    self?.hasMore = self?.pageindex ?? 0 <= pagecount
                }else{
                    self?.hasMore = false
                }
                self?.products = products
            }
            self?.productsCollectionView.reloadData()
            self?.productsCollectionView.safeScrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            print(self?.products?.convertToString ?? "")
        }.store(in: &cancellables)
        
        
        viewModel.$moreProducts.receive(on: DispatchQueue.main).sink { _ in } receiveValue: { [weak self] response  in
            if let products = response?.products {
                if let pagecount = response?.pagecount {
                    self?.hasMore = self?.pageindex ?? 0 <= pagecount
                }else{
                    self?.hasMore = false
                }
                self?.productsCollectionView.performBatchUpdates({
                    let startIndex = self?.products?.products?.count ?? 0
                    let indexPaths = (startIndex..<startIndex + products.count).map { IndexPath(item: $0, section: 0) }
                    self?.products?.products?.append(contentsOf: products)
                    self?.productsCollectionView.insertItems(at: indexPaths)
                    
                }, completion: nil)
            }
        }.store(in: &cancellables)
        
    }
    
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
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
    
    
    private func showSelectedCategoryShimmer(){
        self.view.addSubview(selectedCategoryshimmerView)
        selectedCategoryshimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.separatorView.snp.bottom).offset(10)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.selectedCategoryshimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    private func hideSelectedCategoryShimmer(){
        selectedCategoryshimmerView.removeFromSuperview()
    }
    

    private func showSelectedSubCategoryShimmer(){
        self.view.addSubview(selectedSubCategoryshimmerView)
        selectedSubCategoryshimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.separatorView.snp.bottom).offset(60)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.selectedSubCategoryshimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    private func hideSelectedSubCategoryShimmer(){
        selectedSubCategoryshimmerView.removeFromSuperview()
    }
    
    private func resetLoadedProducts(){
        self.pageindex = 1
        self.hasMore = true
        self.productsCollectionView.safeScrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    private func loadMore(){
        self.pageindex += 1
        self.loadProducts(isLoadMore: true)
    }
    
    
    private func loadProducts(isLoadMore: Bool = false){
        let vendorId = stores?.map({ vendor in
            vendor.id ?? ""
        }).joined(separator: ",") ?? ""
        self.viewModel.loadProducts(categoryId: self.category?.id ?? "", subcategoryId: self.subCategory?.id ?? "", pageIndex: self.pageindex, pageSize: 40, isLoadMore: isLoadMore, pricefrom: prices?.type.rowValue().from, priceto: prices?.type.rowValue().to, vendorID: vendorId.isEmpty ? nil : vendorId)
    }

}
extension CategoryItemsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return self.categories?.categories?.count ?? 0
        }
        return self.products?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as! CategoryItemCell
            cell.iconSize = 56
            if let category = categories?.categories?.get(at: indexPath.row) {
                cell.category = category
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            cell.product = products?.products?.get(at: indexPath.row)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == self.collectionView {
            return UICollectionReusableView()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "VendorProductsHeaderView", for: indexPath) as! VendorProductsHeaderView
            self.header = header
            header.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
            header.isFilterApplied = self.prices != nil || self.stores?.isEmpty == false
            header.clearDidTapped = {
                self.stores = nil
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
                self.subCategory = category
                self.resetLoadedProducts()
                self.loadProducts()
            }
            header.filterDidTapped = {
                let vc = FilterViewController(categoryId: self.category?.id ?? "", productType: self.category?.productType ?? "", delegate: self, prices: self.prices, stores: self.stores)
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
        if collectionView == self.collectionView {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == self.collectionView {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if collectionView == self.productsCollectionView {
            if elementKind == UICollectionView.elementKindSectionFooter {
                if hasMore {
                    (view as? LoadingFooter)?.loadingIndicator.startAnimating()
                }else{
                    (view as? LoadingFooter)?.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if collectionView == self.productsCollectionView {
            if elementKind == UICollectionView.elementKindSectionFooter {
                (view as? LoadingFooter)?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.productsCollectionView {
            return CGSize(width: (collectionView.frame.width - 24) / 2, height: 289.constraintMultiplierTargetValue.relativeToIphone8Height())
        }else{
            return CGSize(width: 65 , height: 102)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.productsCollectionView {
            return 8
        }
        return 16
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.productsCollectionView {
            return 8
        }
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.productsCollectionView {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.productsCollectionView {
            if indexPath.item == (self.products?.products?.count ?? -1) - 4 && !self.viewModel.loadMore && hasMore{
                self.loadMore()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            self.category = self.categories?.categories?.get(at: indexPath.row)
            self.stores = nil
            self.prices = nil
            self.resetLoadedProducts()
            self.viewModel.loadSubCategoriesAndThenLoadProducts(categoryId: self.category?.id ?? "", pageIndex: self.pageindex, pageSize: 40)
            for (index, _ ) in (self.categories?.categories ?? []).enumerated() {
                self.categories?.categories?[index].isSelected = false
            }
            self.categories?.categories?[safe: indexPath.row]?.isSelected = true
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else {
            if let product = self.products?.products?.get(at: indexPath.row) {
                let vc = ProductDetailsViewController(product: product)
                vc.callback = { cartItem in
                    self.instance.setAmount(amount: "\(cartItem?.items?.count ?? 0) items | KD \(cartItem?.cartTotal ?? 0)")
                    self.instance.attach()
                }
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
        }
    }
    
}
extension CategoryItemsViewController:Filter{
    
    func apply(prices: PriceFilter?, stores: [Vendor]) {
        self.resetLoadedProducts()
        self.stores = stores
        self.prices = prices
        self.header?.isFilterApplied = self.prices != nil || self.stores?.isEmpty == false
        self.loadProducts()
    }
}
