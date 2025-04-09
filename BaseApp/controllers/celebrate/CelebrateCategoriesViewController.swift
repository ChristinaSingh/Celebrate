//
//  CelebrateCategoriesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/09/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class CelebrateCategoriesViewController: UIViewController, InputsDelegate {
    func inputDidChange(_ input: Input, value: String) {
        if let index = self.inputs.firstIndex(where: { mInput in
            mInput.id == input.id
        }) {
            self.inputs[safe: index]?.value = value
        }
        if let input = self.inputs.first(where: { mInput in
            mInput.value == nil
        }){
            let inputViewController = CelebrateInputsViewController(delegate: self, input: input)
            self.navigationController?.pushViewController(inputViewController, animated: true)
        }else if self.inputs.filter({ $0.value != nil }).count == self.inputs.count{
            if let presentedViewController = self.navigationController?.viewControllers.last as? CelebrateInputsViewController{
                let allSubcategoryIDs = self.categories
                    .flatMap { $0.subcategories }
                    .filter { $0.isSelected }
                    .compactMap { $0.id }
                    .map { "\($0)" }
                    .joined(separator: ",")
                presentedViewController.proceed(inputs: inputs, subcategories: allSubcategoryIDs, area: self.area, day: self.day, time: self.time, occasions: self.occasions, categories: self.categories)
            }
        }else{
            MainHelper.showErrorMessage(message:"Somthing went wrong".localized)
        }
    }
    

    
    private let area:Area?
    private let day:Day?
    private let time:TimeSlot?
    private let occasions:[CelebrateOcassion]
    private var tableHeightConstraint: Constraint?
    private var inputs:[Input]
    private var categories:[Category]{
        didSet {
            self.tableView.reloadData()
            let maxTableHeight = self.proceedCardView.frame.minY - 20
            let tableContentHeight = CGFloat(self.categories.count) * 70.0
            let finalHeight = min(tableContentHeight, maxTableHeight)
            self.tableHeightConstraint?.update(offset: finalHeight)
        }
    }
    private let viewModel:CelebrateViewModel
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    
    init(area: Area?, day: Day?, time: TimeSlot?, occasions:[CelebrateOcassion]) {
        self.area = area
        self.day = day
        self.time = time
        self.occasions = occasions
        self.categories = []
        self.inputs = []
        self.viewModel = CelebrateViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Options".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    
    lazy private var tableView:UITableView = {
        let table = UITableView()
        
        table.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        table.layer.borderWidth = 1
        table.layer.cornerRadius = 16
        table.separatorStyle = .singleLine
        table.separatorColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        table.register(CelebrateCategoryCell.self, forCellReuseIdentifier: "CelebrateCategoryCell")
        table.separatorInset = .zero
        table.cellLayoutMarginsFollowReadableWidth = false
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
    private let proceedCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    lazy var proceedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Categories")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        headerView.back(vc: self)
        [headerView, tableView, proceedCardView].forEach { view in
            self.view.addSubview(view)
        }
        tableView.dataSource = self
        tableView.delegate = self
        proceedCardView.addSubview(self.proceedBtn)
        self.proceedBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        proceedCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualTo(self.proceedCardView.snp.top)
            self.tableHeightConstraint = make.height.equalTo(1).constraint
        }
        
        self.proceedBtn.tap = {
            let allSubcategoryIDs = self.categories
                    .flatMap { $0.subcategories }
                    .map { "\($0.id ?? "")" }.joined(separator: ",")
            self.viewModel.loadInputs(subCategories: allSubcategoryIDs)
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        
        viewModel.$categories.receive(on: DispatchQueue.main).sink { categories in
            if let categories = categories?.data, categories.isEmpty == false {
                self.categories = categories
            }
        }.store(in: &cancellables)
        
        viewModel.$inputsLoading.receive(on: DispatchQueue.main).sink { isLoading in
            self.proceedBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        
        self.viewModel.$prices.receive(on: DispatchQueue.main).sink { prices in
            if let prices {
                
                let allSubcategoryIDs = self.categories
                    .flatMap { $0.subcategories }
                    .filter { $0.isSelected }
                    .compactMap { $0.id }
                    .map { "\($0)" }
                    .joined(separator: ",")
                let vc = CelebrateBudgetViewController(area: self.area, day: self.day, time: self.time, occasions: self.occasions, categories: self.categories, subcategories: allSubcategoryIDs, inputs: self.inputs, prices: prices)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.store(in: &cancellables)
        
        viewModel.$inputs.receive(on: DispatchQueue.main).sink { categories in
            
            categories?.data?.subCategories?.forEach { category in
                var inputs = category.inputs ?? []
                inputs.forEachIndexed { index, _ in
                    inputs[safe:index]?.subCatId = category.id
                }
                self.inputs.append(contentsOf: category.inputs ?? [])
            }
            if self.inputs.isEmpty == false {
                if let input = self.inputs.first {
                    let inputViewController = CelebrateInputsViewController(delegate: self, input: input)
                    self.navigationController?.pushViewController(inputViewController, animated: true)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.loadCategories(occasions: self.occasions.map({ occasion in occasion.id ?? ""}).joined(separator: ","))
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let maxTableHeight = proceedCardView.frame.minY - 20
//        let tableContentHeight = CGFloat(self.categories.count) * 70.0
//        let finalHeight = min(tableContentHeight, maxTableHeight)
//        tableHeightConstraint?.update(offset: finalHeight)
//    }

    
    private func showShimmer(){
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
    }
}
extension CelebrateCategoriesViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrateCategoryCell") as! CelebrateCategoryCell
        cell.category = self.categories[safe: indexPath.row]
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = .zero
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let category = self.categories[safe: indexPath.row] {
            let vc = CelebrateSubCategoriesViewController(category: category, occasions: self.occasions)
            vc.callback = { [weak self] subcategories in
                self?.categories[safe: indexPath.row]?.subcategories = subcategories
                self?.proceedBtn.enableDisableSaveButton(isEnable: self?.categories.filter({ category in category.subcategories.isEmpty == false }).isEmpty == false)
            }
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
        
    }
}
