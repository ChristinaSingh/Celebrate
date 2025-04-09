//
//  StoresFilterViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/06/2024.
//

import UIKit
import Combine
import SnapKit

class StoresFilterViewController: UIViewController {
    
    private let viewModel = CategoriesViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let categoryId:String
    private let productType:String
    private var vendors: Vendors?
    private var filteredVendors: [Vendor]?
    private var selectedVendors: [Vendor] = []
    private let delegate:FilterSelected
    private let stores:[Vendor]?
    init(categoryId: String, productType:String, delegate:FilterSelected, stores:[Vendor]?) {
        self.categoryId = categoryId
        self.productType = productType
        self.delegate = delegate
        self.stores = stores
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Filter by price".localized.uppercased()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    lazy private var searchTextField: C8TextField = {
        let textField = C8TextField()
        textField.placeholder = "Search for stores".localized
        textField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        textField.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 24
        textField.delegate = nil
        textField.handleBackward = false
        textField.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return textField
    }()
    
    
    lazy private var tableView:UITableView = {
        let table = UITableView()
        table.register(FilterStoreCell.self, forCellReuseIdentifier: "FilterStoreCell")
        table.layer.cornerRadius = 8
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "FilterVendors")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLbl, searchTextField, tableView].forEach { view in
            self.view.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.leading.equalToSuperview().offset(24)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.searchTextField.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading{
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$vendors.receive(on: DispatchQueue.main).sink { vendors in
            self.filteredVendors = vendors?.vendors
            let selectedVendorsDict = Dictionary(uniqueKeysWithValues: self.stores?.map { ($0.id, $0) } ?? [])
            for (index, vendor) in (self.filteredVendors ?? []).enumerated() {
                if let _ = selectedVendorsDict[vendor.id] {
                    self.filteredVendors?[index].isSelected = true
                }else{
                    self.filteredVendors?[index].isSelected = false
                }
            }
            self.vendors = vendors
            self.vendors?.vendors = self.filteredVendors
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.loadFilterVendors(eventDate: OcassionDate.shared.getDate(), locationID: OcassionLocation.shared.getAreaId(), categoryID: categoryId, productType: productType, ocassionID: "1")
    }
    
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
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
    
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let searchText = textField.text, !searchText.isEmpty else {
            self.filteredVendors = self.vendors?.vendors
            self.tableView.reloadData()
            return
        }
        self.filteredVendors = self.vendors?.vendors?.filter { vendor in
            vendor.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        self.tableView.reloadData()
    }
    
    
    func reset(){
        if let vendors = self.vendors?.vendors {
            for (index, _) in vendors.enumerated() {
                self.vendors?.vendors?[index].isSelected = false
            }
        }
        
        if let vendors = self.filteredVendors{
            for (index, _) in vendors.enumerated() {
                self.filteredVendors?[index].isSelected = false
            }
        }
        
        self.selectedVendors.removeAll()
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    
    func getSelections() -> [Vendor]{
        return self.vendors?.vendors?.filter { vendor in
            vendor.isSelected
        } ?? []
    }
    
}
extension StoresFilterViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredVendors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterStoreCell", for: indexPath) as! FilterStoreCell
        let vendor = self.filteredVendors?[safe: indexPath.row]
        cell.vendor = vendor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vendor = self.filteredVendors?[safe: indexPath.row] else { return }
        if let index = self.selectedVendors.firstIndex(where: { $0.id == vendor.id }) {
            self.selectedVendors.removeIfIndexExists(at: index)
        } else {
            self.selectedVendors.append(vendor)
        }
        if let index = self.vendors?.vendors?.firstIndex(where: { $0.id == vendor.id }){
            self.vendors?.vendors?[index].isSelected.toggle()
        }
        
        if let index = self.filteredVendors?.firstIndex(where: { $0.id == vendor.id }){
            self.filteredVendors?[index].isSelected.toggle()
        }
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.delegate.isSelected()
    }
}
