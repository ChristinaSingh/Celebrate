//
//  MyWishListViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit
import Combine

class MyWishListViewController: UIViewController, DaySelectionDelegate , AreaSelectionDelegate {
    var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    var products:Products?
    var selectedProduct:Product?
    let viewModel = ProductsViewModel()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "WishListView")
        return view
    }()
    
    let emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "empty_wish_list"), message: "Looks like you don’t have any items in your wishlist".localized, imgSize: CGSize(width: 120, height: 120))
        view.icon = UIImage(named: "empty_wish_list")
        view.message = "Looks like you don’t have any items in your wishlist".localized
        return view
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell" )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    let headerView:HeaderView = {
        let view = HeaderView(title: "Wishlist".localized)
        view.backgroundColor = .white
        return view
    }()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title = "Wishlist".localized
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        emptyState.message = "Looks like you don’t have any items in your wishlist".localized
        emptyState.icon = UIImage(named: "empty_wish_list")
        headerView.back(vc: self)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView , collectionView , emptyState].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        emptyState.isHidden = true
        emptyState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.5)
            make.height.equalTo(200)
            
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$wishList.receive(on: DispatchQueue.main).sink { products in
            if self.viewModel.loading {return}
            if let products = products , products.products?.isEmpty == false{
                self.products = products
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
                self.emptyState.isHidden = true
            }else{
                self.collectionView.isHidden = true
                self.emptyState.isHidden = false
            }
        }.store(in: &cancellables)
        
        viewModel.$addToWishListloading.receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        
        viewModel.$productAddedToWishList.receive(on: DispatchQueue.main).sink { response in
            if let _ = response {
                self.products = nil
                self.collectionView.reloadData()
                self.loadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$removeFromWishListloading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        
        viewModel.$productRemovedFromWishList.dropFirst().receive(on: DispatchQueue.main).sink { productRemovedFromWishList in
            if let _ = productRemovedFromWishList {
                self.products = nil
                self.collectionView.reloadData()
                self.loadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModel.loading {return}
            MainHelper.handleApiError(error)
            self.collectionView.isHidden = true
            self.emptyState.isHidden = false
        }.store(in: &cancellables)
        loadData()
    }
    
    func loadData(){
        viewModel.getWishList(body: ProductsParameters(eventDate: OcassionDate.shared.getDate() , locationID: OcassionLocation.shared.getAreaId() , customerID: User.load()?.details?.id ?? ""))
    }
    
    
    func showShimmer(){
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
    
    
    func hideShimmer(){
        shimmerView.removeFromSuperview()
    }
    
    func areaDidSelected(area:Area?) {
        if let area = area {
            OcassionLocation.shared.save(area: area)
            self.loadData()
        }
    }
    
    func dayDidSelected(day: Day?) {
        if let day = day {
            OcassionDate.shared.save(date: DateFormatter.standard.string(from: day.date))
            self.loadData()
        }
    }
    
    func timeDidSelected(time: PreferredTime?) {
        if let time = time {
            OcassionDate.shared.saveTime(time: time.displaytext ?? "")
            if let _ =  OcassionDate.shared.getDate(), let _ =  OcassionLocation.shared.getArea() {
                self.loadData()
            }
        }
    }

}
extension MyWishListViewController:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.products?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = products?.products?.get(at: indexPath.row)
        cell.favoriteBtn.isHidden = false
        cell.favoriteBtn.isUserInteractionEnabled = true
        cell.favoriteBtn.tap {
            if cell.favoriteBtn.isSelected {
                self.viewModel.removeProductFromWishList(productId:  cell.product?.id ?? "")
            }else {
                self.viewModel.addProductToWishList(productId:  cell.product?.id ?? "")
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 24) / 2, height: 289.constraintMultiplierTargetValue.relativeToIphone8Height())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = products?.products?.get(at: indexPath.row) else { return }
        self.selectedProduct = product
        if OcassionDate.shared.getEventDate() == nil && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(on: self, cartType: .normal , selectedDate: OcassionDate.shared.getEventDate() , delegate: self , areaDelegate: self)
        }else{
            let vc = ProductDetailsViewController(product: product)
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
    }
}

