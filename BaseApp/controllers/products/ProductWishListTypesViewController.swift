//
//  ProductWishListTypesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import UIKit
import SnapKit
import Combine

class ProductWishListTypesViewController: UIViewController {
    
    private let product:Product
    private let viewModel:ProductsViewModel
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    init(product: Product) {
        self.product = product
        self.viewModel = ProductsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Save to".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    private let saveCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
        
    
    private lazy var saveBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Save".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.button.setTitleColor(UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5), for: .normal)
        btn.button.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.button.layer.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        btn.button.isUserInteractionEnabled = false
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    private lazy var tableView:UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.register(WishListTypeCell.self, forCellReuseIdentifier: "WishListTypeCell")
        return table
    }()
    
    
    private let shimmerView: ShimmerView = {
        let view = ShimmerView(nibName: "WishListTypes")
        return view
    }()
    
    private var types:[WishListType] = []
    
    var callback:((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView, tableView , saveCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        saveCardView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        saveCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.saveCardView.snp.top)
        }
        
        
        saveBtn.tap = {
            self.addToWishList()
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.shimmerView.showShimmer(vc: self)
            }else{
                self.shimmerView.hideShimmer(vc: self)
            }
        }.store(in: &cancellables)
        
        viewModel.$wishList.receive(on: DispatchQueue.main).sink { products in
            if self.viewModel.loading {return}
            self.types.insert(WishListType(icon: "heart", title: "Wishlist".localized, subTitle: "\(products?.products?.count ?? 0) products"), at: 0)
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        
        viewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModel.loading {return}
            self.types.insert(WishListType(icon: "heart", title: "Wishlist".localized, subTitle: "0 products"), at: 0)
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        
        viewModel.$addToWishListloading.receive(on: DispatchQueue.main).sink { isLoading in
            self.headerView.cancelBtn.isUserInteractionEnabled = !isLoading
            self.tableView.isUserInteractionEnabled = !isLoading
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        
        viewModel.$productAddedToWishList.receive(on: DispatchQueue.main).sink { response in
            if let _ = response {
                self.callback?(true)
                self.dismiss(animated: true){
                    MainHelper.showToastMessage(message: "Product added successfully to wishlist".localized, style: .success, position: .Bottom)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$addToWishListError.receive(on: DispatchQueue.main).sink{ error in
            if let error = error {
                self.failToAddToWishList(error: error)
            }
        }.store(in: &cancellables)
        
        
        viewModel.getWishList(body: ProductsParameters(eventDate: OcassionDate.shared.getDate() , locationID: OcassionLocation.shared.getAreaId() , customerID: User.load()?.details?.id ?? ""))
    }
    
    
    private func addToWishList(){
        viewModel.addProductToWishList(productId: self.product.id ?? "")
    }
    
    
    private func failToAddToWishList(error:Error){
        if let error = error as? ErrorResponse{
            switch error {
            case .error(let code,  _, _):
                switch code {
                case 403:
                    MainHelper.showToastMessage(message: "session has been expired".localized, style: .error, position: .Bottom)
                    break
                default:
                    break
                }
            }
        }else{
            MainHelper.showToastMessage(message: "couldn't add product to wishlist".localized, style: .error, position: .Bottom)
        }
    }
    
    
    private func enableSaveBtn(){
        saveBtn.button.setTitleColor(.white, for: .normal)
        saveBtn.button.layer.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
        saveBtn.button.isUserInteractionEnabled = true
    }

}
extension ProductWishListTypesViewController:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTypeCell", for: indexPath) as! WishListTypeCell
        cell.type = types.get(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for (index , _) in self.types.enumerated() {
            self.types[index].isSelected = false
        }
        self.types[safe: indexPath.row]?.isSelected = true
        tableView.reloadData()
        self.enableSaveBtn()
    }
}
