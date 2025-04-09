//
//  AddressesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit
import Combine

class AddressesViewController: UIViewController {
    
    private var addresses: [Address] = []
    private let viewModel = AddressesViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()

    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Addressess")
        return view
    }()
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Saved address".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy private var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        headerView.back(vc: self)
        emptyState.message = "Looks like you don’t have any saved address".localized
        emptyState.icon = UIImage(named: "no_addresses")
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, tableView, emptyState, addAddressCardView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
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
            vc.addressDidAdd = { _ in
                self.viewModel.getAddresses()
            }
            vc.isModalInPresentation = true
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
                self.addresses = addresses
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
        
        viewModel.getAddresses()
    }
    
    
    
    private func showShimmer(){
        self.tableView.isHidden = true
        self.emptyState.isHidden = true
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
        self.tableView.isHidden = false
    }
    

}
extension AddressesViewController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let address = addresses.get(at: indexPath.row)
        cell.address = address
        cell.editBtn.tap {
            Task{
                await MainActor.run {
                    if let address = address {
                        let vc = EditAddressViewController(address: address)
                        vc.addressDidAdd = { _ in
                            self.viewModel.getAddresses()
                        }
                        vc.isModalInPresentation = true
                        self.present(vc, animated: true)
                    }else{
                        MainHelper.showToastMessage(message: "Unable to edit address due to invalid details. Please contact us for assistance.".localized, style: .error, position: .Bottom)
                    }
                }
            }
        }
        cell.deleteBtn.tap {
            self.addresses[safe: indexPath.row]?.loading = true
            self.reloadRow(indexPath: indexPath, tableView: tableView)
            self.viewModel.deleteAddress(addressId: address?.id ?? "") { res, err in
                DispatchQueue.main.async {
                    if let _ = res {
                        if self.addresses.indices.contains(indexPath.row) {
                            self.addresses.removeIfIndexExists(at: indexPath.row)
                            tableView.reloadData()
                        }
                        self.emptyState.isHidden = !self.addresses.isEmpty
                        self.tableView.isHidden = self.addresses.isEmpty
                    }else if let _ = err {
                        self.addresses[safe: indexPath.row]?.loading = false
                        self.reloadRow(indexPath: indexPath, tableView: tableView)
                        MainHelper.showToastMessage(message: "Failed to delete the address. Please try again.".localized, style: .error, position: .Bottom)
                    }
                }
            }
        }
        return cell
    }
    
    
    func reloadRow(indexPath:IndexPath , tableView:UITableView){
        UIView.performWithoutAnimation {
            tableView.performBatchUpdates {
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
}
