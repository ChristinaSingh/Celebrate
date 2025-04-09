//
//  TimeSoltsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/08/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

protocol TimeSlotDelegate {
    func timeDidSelected(slot:Slot?)
}

class TimeSoltsViewController:UIViewController {
    
    private let product:Product
    private let productViewModel:ProductsViewModel
    private var productTimeSlots: DeliveryTimes?
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var date:String
    private let selectedTimeSlot:Slot?
    init(product: Product, date:String, slot:Slot? = nil) {
        self.product = product
        self.date = date
        self.selectedTimeSlot = slot
        self.productViewModel = ProductsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "TimeSlots")
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
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
        table.register(ProductDetailsDeliveryTimeCell.self, forCellReuseIdentifier: "ProductDetailsDeliveryTimeCell")
        return table
    }()
    
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Delivery time".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let saveCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    lazy var saveBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Skip".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    var callback:((Slot?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView , tableView, saveCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        saveCardView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(self.selectedTimeSlot == nil ? 0 : 48)
        }
        
        saveCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.selectedTimeSlot == nil ? 0 : 101)
            make.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.saveCardView.snp.top)
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        saveBtn.tap = {
            self.timeDidSelected(slot: self.selectedTimeSlot)
        }
        
        self.productViewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        self.productViewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.productViewModel.$productTimeSlots.receive(on: DispatchQueue.main).sink { timeSlots in
            self.productTimeSlots = timeSlots
            if let index = self.productTimeSlots?.slots?.firstIndex(where: { slot in
                slot.id == self.selectedTimeSlot?.id
            }){
                self.productTimeSlots?.slots?[safe: index]?.isSelected = true
            }
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        self.productViewModel.getTimeSlots(productId: self.product.id, date: date)
    }
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
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

extension TimeSoltsViewController:UITableViewDelegate, UITableViewDataSource, TimeSlotDelegate {
    
    func timeDidSelected(slot:Slot?) {
        self.productTimeSlots?.slots?.forEachIndexed({ index, _ in
            self.productTimeSlots?.slots?[safe: index]?.isSelected = false
        })
        if let index = self.productTimeSlots?.slots?.firstIndex(where: { _slot in
            slot?.id == _slot.id
        }){
            self.productTimeSlots?.slots?[safe: index]?.isSelected = true
        }
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
        self.dismiss(animated: true) {
            self.callback?(slot)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDeliveryTimeCell", for: indexPath) as! ProductDetailsDeliveryTimeCell
        cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        cell.deliveryTimes = productTimeSlots
        cell.delegate = self
        cell.timeSlotType.timeTypeChanged = { type in
            self.timesType(timeType: type)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let am = Int(Double((productTimeSlots?.am()?.count ?? 0) / 2).rounded(.up))
//        let pm = Int(Double((productTimeSlots?.pm()?.count ?? 0) / 2).rounded(.up))
//        let pmSpaces = (pm + 1) * 16
//        let amSpaces = (am + 1) * 16
        return UITableView.automaticDimension//productTimeSlots?.timeType == .AM ? CGFloat((am * 84) + 70 + amSpaces) : CGFloat((pm * 84) + 70 + pmSpaces)
    }
    
    func timesType(timeType: TimeSlotType) {
        self.productTimeSlots?.timeType = timeType
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
}
