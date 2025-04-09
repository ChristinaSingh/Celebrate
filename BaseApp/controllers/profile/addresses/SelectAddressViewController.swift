//
//  SelectAddressViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class SelectAddressViewController:UIViewController {
    
    private var addresses: [Address]
    private let viewModel:AddressesViewModel
    private var cancellables: Set<AnyCancellable>
    private let locationId:String?
    private let areaName:String?
    private let cartType:CartType?
    init(locationId:String? = nil, areaName:String? = nil, cartType:CartType? = nil) {
        self.locationId = locationId
        self.addresses = []
        self.areaName = areaName
        self.cartType = cartType
        self.viewModel = AddressesViewModel()
        self.cancellables = Set<AnyCancellable>()
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
        let view = HeaderViewWithCancelButton(title: "Choose a delivery address".localized)
        view.backgroundColor = .white
        return view
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Addressess")
        return view
    }()
    
    
    lazy private var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return table
    }()
    
    private let emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "no_addresses"), message: "Looks like you don’t have any saved address".localized, imgSize: CGSize(width: 120, height: 120))
        return view
    }()
    
    
    private let addAddressCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    private let addNewAddressBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 24
        btn.setTitle("Add new address".localized, for: .normal)
        return btn
    }()
    
    var callback:((Address?) -> ())?
    var cancelCallback:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        emptyState.message = "Looks like you don’t have any saved address".localized
        emptyState.icon = UIImage(named: "no_addresses")
        headerView.cancelBtn.tap {
            self.dismiss(animated: true) {
                self.cancelCallback?()
            }
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, tableView, emptyState, addAddressCardView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        emptyState.isHidden = true
        emptyState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.5)
            make.height.equalTo(200)
            
        }
        
        addAddressCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.addAddressCardView.snp.top)
        }

        addAddressCardView.addSubview(addNewAddressBtn)
        addNewAddressBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        addNewAddressBtn.tap {
            let vc = AddAddressViewController()
            vc.locationId = self.locationId
            vc.areaName = self.areaName
            vc.isModalInPresentation = true
            vc.addressDidAdd = { _ in
                self.viewModel.getAddresses(locationId: self.locationId ?? "")
            }
            self.present(vc, animated: true)
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.addAddressCardView.isHidden = true
                self.showShimmer()
            }else{
                self.hideShimmer()
                self.addAddressCardView.isHidden = false
            }
        }.store(in: &cancellables)
        
        viewModel.$addresses.receive(on: DispatchQueue.main).sink { addresses in
            if self.viewModel.loading {return}
            if let addresses = addresses?.addresses , !addresses.isEmpty {
                self.emptyState.isHidden = true
                self.tableView.isHidden = false
                if self.cartType == .gift {
                    self.addresses = addresses.filter({ address in
                        address.location != nil
                    })
                }else{
                    self.addresses = addresses
                }
                self.tableView.reloadData()
            }else{
                self.emptyState.isHidden = false
                self.tableView.isHidden = true
            }
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModel.loading {return}
            self.emptyState.isHidden = false
            self.tableView.isHidden = true
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        viewModel.getAddresses(locationId: self.locationId ?? "")
    }

    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        self.tableView.isHidden = true
        self.emptyState.isHidden = true
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
        self.tableView.isHidden = false
        shimmerView.removeFromSuperview()
    }
    
}
extension SelectAddressViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let address = addresses.get(at: indexPath.row)
        cell.address = address
        cell.actions.isHidden = true
        cell.editBtn.isHidden = true
        cell.deleteBtn.isHidden = true
        cell.actions.removeFromSuperview()
        cell.mobileLbl.snp.remakeConstraints { make in
            make.leading.equalTo(cell.addressLbl.snp.leading)
            make.trailing.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(cell.addressLbl.snp.bottom).offset(12)
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.callback?(self.addresses.get(at: indexPath.row))
        }
    }
 
}
