//
//  OrderItemsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/09/2024.
//

import Foundation
import SnapKit
import UIKit


class OrderItemsViewController:UIViewController{
    
    private let orderDetails: Order?
    
    init(orderDetails: Order?) {
        self.orderDetails = orderDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var tableHeightConstraint: Constraint?
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Ordered items".localized)
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var tableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 0.1).cgColor
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(containerView)
        headerView.back(vc: self)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView , tableView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview()
            self.tableHeightConstraint = make.height.equalTo(1).constraint
        }
        
        let maxTableHeight = self.view.frame.height - 20
        let tableContentHeight = CGFloat(1) * 80.0
        let finalHeight = min(tableContentHeight, maxTableHeight)
        self.tableHeightConstraint?.update(offset: finalHeight)
    }
    
}


extension OrderItemsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetails == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell") as! OrderItemCell
        cell.order = self.orderDetails
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
