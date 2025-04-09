//
//  FilterViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/06/2024.
//

import UIKit
import SnapKit

class FilterViewController: UIViewController {
    
    private let categoryId:String
    private let productType:String
    private let delegate:Filter
    private let prices:PriceFilter?
    private let stores:[Vendor]?
    init(categoryId: String, productType:String, delegate:Filter, prices: PriceFilter?, stores:[Vendor]?) {
        self.categoryId = categoryId
        self.productType = productType
        self.delegate = delegate
        self.prices = prices
        self.stores = stores
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Filter".localized)
        view.withResetBtn = true
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private let applyFilterView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    private lazy var applyFilterBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Apply".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    
    private let separator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    
    lazy private var sideMenuTV:UITableView = {
        let table = UITableView()
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        table.register(FilterSideMenuCell.self, forCellReuseIdentifier: "FilterSideMenuCell")
        table.layer.cornerRadius = 8
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    
    private let filterContentView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let bar:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "vertical_bar")
        return icon
    }()
    
    
    
    lazy private var pricesVC = PriceFilterViewController(delegate: self, prices: self.prices)
    lazy private var storesVC = StoresFilterViewController(categoryId: categoryId, productType: productType, delegate: self, stores: self.stores)
    lazy private var sideMenu:[FilterSideMenu] = [FilterSideMenu(title: "Price".localized, vc: pricesVC, isSelected: true)]

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.cancel(vc: self)
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        if !categoryId.isEmpty {
            sideMenu.append(FilterSideMenu(title: "Stores".localized, vc: storesVC, isSelected: false))
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, contentView, applyFilterView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        applyFilterView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.applyFilterView.snp.top).offset(-24)
        }
        
        [applyFilterBtn].forEach { view in
            self.applyFilterView.addSubview(view)
        }
    
        
        applyFilterBtn.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
       
        
        [sideMenuTV, bar , separator, filterContentView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        sideMenuTV.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        
        bar.frame = CGRect(x: sideMenuTV.frame.origin.x, y: 19, width: 4, height: 46)
        separator.snp.makeConstraints { make in
            make.leading.equalTo(self.sideMenuTV.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        filterContentView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(self.separator.snp.trailing)
        }
        
        headerView.resetDidTapped = {
            self.storesVC.reset()
            self.pricesVC.reset()
            self.applyFilterBtn.enableDisableSaveButton(isEnable: true)
        }
        
        self.applyFilterBtn.tap = {
            self.dismiss(animated: true) {
                self.delegate.apply(prices: self.pricesVC.getSelections(), stores: self.storesVC.getSelections())
            }
        }
        isSelected()
        ViewEmbedder.embed(parent: self, container: self.filterContentView, child: sideMenu.first?.vc ?? UIViewController(), previous: self.children.first)
    }


}
extension FilterViewController:UITableViewDelegate, UITableViewDataSource, FilterSelected {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSideMenuCell", for: indexPath) as! FilterSideMenuCell
        cell.menuItem = sideMenu.get(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for (index, _) in self.sideMenu.enumerated() {
            self.sideMenu[index].isSelected = false
        }
        self.sideMenu[safe: indexPath.row]?.isSelected = true
        tableView.reloadData()
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                self.bar.frame.origin.y = cell.frame.origin.y + ((self.bar.frame.height / 2) - 4)
            }
        }
        ViewEmbedder.embed(parent: self, container: self.filterContentView, child: self.sideMenu[safe: indexPath.row]?.vc ?? UIViewController(), previous: self.children.first)
    }
    
    func isSelected() {
        self.applyFilterBtn.enableDisableSaveButton(isEnable: true)
    }


}
