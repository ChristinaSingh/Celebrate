//
//  OrdersViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit
import Combine


protocol OrdersDelegate {
    func viewOrderDetails(order: Order?)
    func rateOrder(order: Order?)
}

class OrdersViewController: UIViewController {
    
   
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "OrdersHistory")
        return view
    }()
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Orders".localized)
        view.backgroundColor = .white
        view.withSearchBtn = true
        view.separator.isHidden = true
        return view
    }()
    
    
    private lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(OrderCategoryCell.self, forCellWithReuseIdentifier: "OrderCategoryCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    let separator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(OrderHistoryCell.self, forCellReuseIdentifier: "OrderHistoryCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:OrdersViewModel = OrdersViewModel()
    private var response:Orders?
    private var orders:[Order]? = []{
        didSet{
            if orders?.count ?? 0 > 0 {
                self.emptyState.isHidden = true
                self.tableView.isHidden = false
                tableView.reloadData()
            }else{
                self.emptyState.isHidden = false
                self.tableView.isHidden = true
                tableView.reloadData()
            }
        }
    }
    private var page:Int = 1
    private var categories:[OrderCategoryModel] = [OrderCategoryModel(title: "allOrders".localized, category: .all, isSelected: true),
                                                   OrderCategoryModel(title: "Paid".localized, category: .paid),
                                                   OrderCategoryModel(title: "Confirmed".localized, category: .confirmed),
                                                   OrderCategoryModel(title: "Completed".localized, category: .completed),
                                                   OrderCategoryModel(title: "Cancelled".localized, category: .cancelled),
                                                   OrderCategoryModel(title: "refundRequested".localized, category: .refunded),
                                                   OrderCategoryModel(title: "Pop-ups".localized, category: .popups)]
    private let emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "no_orders"), message: "no_orders_found".localized, imgSize: CGSize(width: 120, height: 120))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(containerView)
        emptyState.message = "no_orders_found".localized
        emptyState.icon = UIImage(named: "no_orders")
        headerView.back(vc: self)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, collectionView, separator, tableView , emptyState].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.height.equalTo(46)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom)
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.separator.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(180)
        }
                
        viewModel.$loading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            if isLoading {
                self?.showShimmer()
            }else{
                self?.hideShimmer()
            }
            
        }.store(in: &cancellables)
        
        viewModel.$orders.receive(on: DispatchQueue.main).sink { [weak self] orders in
            self?.response = orders
            self?.orders?.append(contentsOf: (orders?.orders ?? []).sorted(by: { o1, o2 in
                (o1.id?.toInt() ?? 0) > (o2.id?.toInt() ?? 0)
            }))
        }.store(in: &cancellables)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadOrders), name: Notification.Name("order.postponed"), object: nil)
        loadOrders()
    }
    
    @objc private func loadOrders(){
        self.orders?.removeAll()
        viewModel.orders(page: page)
    }
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
}
extension OrdersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderCategoryCell", for: indexPath) as! OrderCategoryCell
        cell.category = categories.get(at: indexPath.row)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let category = categories.get(at: indexPath.row){
            return CGSize(width: category.title.width(withConstrainedHeight: 46, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)!) + 16, height: 46)
        }
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resetCategories()
        self.categories[safe: indexPath.row]?.isSelected = true
        self.orders = self.response?.ordersBy(category: self.categories[safe: indexPath.row]?.category, orders: self.response?.orders)
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    private func resetCategories(){
        for (index, _) in categories.enumerated(){
            self.categories[index].isSelected = false
        }
    }
}
extension OrdersViewController: UITableViewDelegate, UITableViewDataSource, OrdersDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryCell
        cell.delegate = self
        cell.order = self.orders?.get(at: indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (orders?.count ?? 3) - 3 == indexPath.row  {
//            self.page += 1
//            loadOrders()
//        }
    }
    
    
    func viewOrderDetails(order: Order?) {
        let vc = OrderDetailsViewController(order: order)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rateOrder(order: Order?) {
        let vc = RateOrderViewController(order: order)
        vc.isModalInPresentation = true
        vc.callback = {
            let vc = AuthWelcomeViewController(service: .Rate)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    
}
