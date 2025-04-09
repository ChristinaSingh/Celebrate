//
//  OrderDetailsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

enum OrderDetailsSection: Int {
    case orderDetails = 0
    case orderPayment = 1
    case orderLocation = 2
}

class OrderDetailsViewController:UIViewController {
    
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:OrdersViewModel = OrdersViewModel()
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "OrderDetails")
        return view
    }()
    private var order:Order?
    private var details:[OrderDetailsSection] = []
    init(order: Order?) {
        self.order = order
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
    
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(OrderDetailsCell.self, forCellReuseIdentifier: "OrderDetailsCell")
        tableView.register(OrderPaymentDetailsCell.self, forCellReuseIdentifier: "OrderPaymentDetailsCell")
        tableView.register(OrderLocationCell.self, forCellReuseIdentifier: "OrderLocationCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Order details".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    private let actionsCard:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    private let editBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 24
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        btn.setTitle("EDIT".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return btn
    }()
    
    
    private let rateBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Rate".localized, for: .normal)
        btn.layer.cornerRadius = 24
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return btn
    }()
    
    
    private lazy var actionsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editBtn , rateBtn])
        stack.spacing = 16
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let errorState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "no_orders"), message: "no_orders_found".localized, imgSize: CGSize(width: 120, height: 120))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorState.icon = UIImage(named: "no_orders")
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(containerView)
        headerView.back(vc: self)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView , tableView , errorState, actionsCard].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        actionsCard.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        
        actionsCard.addSubview(actionsStack)
        actionsStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.actionsCard.snp.top)
        }
        
        errorState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(180)
        }
        
        errorState.isHidden = true
        
        self.viewModel.$orderDetails.receive(on: DispatchQueue.main).sink { order in
            self.order = order
            self.manageOrderActions()
            self.details.removeAll()
            self.details.append(.orderDetails)
            self.details.append(.orderPayment)
            self.details.append(.orderLocation)
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            if isLoading {
                self?.showShimmer()
            }else{
                self?.hideShimmer()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            guard let error = error else { return }
            self.tableView.isHidden = true
            self.actionsCard.isHidden = true
            self.errorState.isHidden = false
            MainHelper.handleApiError(error){_, message in
                self.errorState.message = message ?? "Somthing went wrong".localized
            }
            
        }.store(in: &cancellables)
        
        viewModel.$indicatorLoading.receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        
        viewModel.$postponeOrder.dropFirst().receive(on: DispatchQueue.main).sink { postPone in
            NotificationCenter.default.post(name: Notification.Name("order.postponed") , object: nil)
            self.orderDetails()
        }.store(in: &cancellables)
        
        viewModel.$cancelOrder.dropFirst().receive(on: DispatchQueue.main).sink { postPone in
            NotificationCenter.default.post(name: Notification.Name("order.postponed") , object: nil)
            self.orderDetails()
        }.store(in: &cancellables)
    
        orderDetails()
        editBtn.tap {
            self.editOrder()
        }
        
       
        rateBtn.tap {
            let vc = RateOrderViewController(order: self.order)
            vc.isModalInPresentation = true
            vc.callback = {
                let vc = AuthWelcomeViewController(service: .Rate)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.present(vc, animated: true)
        }
        
        if order?.orderCategory() == .completed {
            self.rateBtn.isHidden = order?.rated != nil
        }else{
            self.rateBtn.isHidden = true
        }
    }
    
    private func editOrder(){
        let vc = EditOrderSheet()
        vc.callback = { action in
            switch action {
            case .postpone:
                ConfirmationAlert.show(on: self, title: "Postpone event?".localized, message: "By proceeding you are agreeing to our terms & conditions".localized){
                    CalendarViewController.show(on: self, cartType: .ai , delegate: self)
                }
                break
            case .cancel:
                ConfirmationAlert.show(on: self, title: "Cancel event?".localized, message: "By proceeding you are agreeing to our terms & conditions".localized){
                    self.viewModel.cancelOrder(orderId: self.order?.id ?? "", reason: "cancel")
                }
                break
            default:
                break
            }
        }
        SheetPresenter.shared.presentSheet(vc, on: self, height: 234)
    }
    
    
    private func orderDetails(){
        self.viewModel.orderDetails(orderId: self.order?.id ?? "")
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
    
    
    private func manageOrderActions(){
        switch order?.orderCategory() {
        case .all: break
        case .cancelled:
            self.hideActions()
            break
        case .completed:
            if order?.rated == nil {
                self.showActions()
            }else{
                self.hideActions()
            }
            self.editBtn.isHidden = true
            break
        case .confirmed: break
        case .paid: break
        case .refunded: break
        default: break
        }
    }
    
    
    private func showActions(){
        self.actionsCard.isHidden = false
        self.tableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.actionsCard.snp.top)
        }
    }
    
    
    private func hideActions(){
        self.actionsCard.isHidden = true
        self.tableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension OrderDetailsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch details[safe: indexPath.row] {
        case .orderDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell") as! OrderDetailsCell
            cell.order = self.order
            cell.viewItemsBtn.tap {
                let vc = OrderItemsViewController(orderDetails: self.order)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case .orderPayment:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPaymentDetailsCell") as! OrderPaymentDetailsCell
            cell.order = self.order
            return cell
        case .orderLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderLocationCell") as! OrderLocationCell
            cell.order = self.order
            return cell
        case .none:
            return UITableViewCell()
        }
        
    }
}
extension OrderDetailsViewController:DaySelectionDelegate {
    func dayDidSelected(day: Day?) {
        if let day = day {
            let dateFormatter = DateFormatter.standard
            let date = dateFormatter.string(from: day.date)
            viewModel.postponeOrder(orderId: self.order?.id ?? "", vendorId: self.order?.vendor?.id ?? "", date: date)
        }
    }
    
    func timeDidSelected(time: PreferredTime?) {}
}
