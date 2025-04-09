//
//  CompaniesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit
import SnapKit
import Combine


class CompaniesViewController: UIViewController {
    
    private var hasMore:Bool = true
    private var isSearching:Bool = false
    private let viewModel:CompaniesViewModel = CompaniesViewModel()
    var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Companies".localized
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    private let searchView:CardView = {
        let card = CardView()
        card.backgroundColor = .white
        card.cornerRadius = 24
        card.shadowOffsetHeight = 0
        card.shadowOffsetWidth = 0
        card.shadowColor = .clear
        card.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        card.layer.borderWidth = 1
        return card
    }()
    

    
    lazy var searchTF:UITextField = {
        let lbl = UITextField()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.placeholder = "Search from over 100+ companies".localized
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.delegate = self
        return lbl
    }()
    
    private let searchIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        return icon
    }()
    
    
    private let searchBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private var vendors : [Vendor]? = []
    private var allVendors : [Vendor]? = []
    
    
    lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(VendorItemTVCell.self, forCellReuseIdentifier: "VendorItemTVCell")
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    
    lazy var loadMoreView:LoadingTVFooter = {
        let loading = LoadingTVFooter(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        loading.loadingIndicator.startAnimating()
        return loading
    }()
    
    let shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Companies")
        return view
    }()
    
    private var body = VendorsBody(eventDate: OcassionDate.shared.getDate(), locationID: OcassionLocation.shared.getAreaId(), start: "1", size: "20", searchtxt: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observers()
        setup()
        actions()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewModel.getVendors(body: body)
        
    }
    
    
    func setup(){
        backBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        backBtn.tintColor = .black
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerView.addSubview(headerView)
        self.containerView.addSubview(tableView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        
        [backBtn , titleLbl , searchView].forEach { view in
            self.headerView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        
        [searchTF , searchIcon , searchBtn].forEach { view in
            self.searchView.addSubview(view)
        }

        
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        searchBtn.isHidden = true
        searchBtn.isUserInteractionEnabled = false
        searchBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.constraintMultiplierTargetValue.relativeToIphone8Width())
            make.bottom.equalToSuperview().offset(-16.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.isSearching = true
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.isSearching = false
        if let searchText = searchTF.text, searchText.isEmpty {
            self.vendors = allVendors
            self.tableView.reloadData()
        }
    }

    func actions(){
        self.backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func observers(){
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$vendors.receive(on: DispatchQueue.main).sink { vendors in
            if let vendors = vendors {
                self.vendors = vendors.vendors
                self.allVendors = vendors.vendors
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$searchedVendors.receive(on: DispatchQueue.main).sink { vendors in
            if let vendors = vendors {
                self.vendors = vendors.vendors
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$moreVendors.receive(on: DispatchQueue.main).sink { vendors in
            self.tableView.tableFooterView = nil
            if let vendors = vendors?.vendors {
                self.hasMore = vendors.count  >= (self.body.size?.toInt() ?? 0)
                self.tableView.performBatchUpdates({
                    let startIndex = self.vendors?.count ?? 0
                    let indexPaths = (startIndex..<startIndex + vendors.count).map { IndexPath(item: $0, section: 0) }
                    self.vendors?.append(contentsOf: vendors)
                    self.allVendors = self.vendors
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }, completion: nil)
            }
        }.store(in: &cancellables)
    }
    
    func loadMore(){
        self.tableView.tableFooterView = loadMoreView
        self.body.start = ((self.body.start?.toInt() ?? 0) + 1).toString()
        self.viewModel.getVendors(body: body , loadMore: true)
    }
    
    private func showShimmer(){
        self.tableView.isHidden = true
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
        self.tableView.isHidden = false
        shimmerView.removeFromSuperview()
    }

}
extension CompaniesViewController:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorItemTVCell", for: indexPath) as! VendorItemTVCell
        cell.vendor = vendors?.get(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vendor = vendors?.get(at: indexPath.row){
            let vc = CompanyProfileViewController(vendor: vendor)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == (self.vendors?.count ?? -1) - 1) && !self.viewModel.loadMore && hasMore && !isSearching{
            self.loadMore()
        }
    }
}
extension CompaniesViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string){
            if text.isEmpty {
                self.vendors = allVendors
                self.tableView.reloadData()
            }else{
                self.viewModel.findVendors(text: text)
            }
        }
        return true
    }
    
}
