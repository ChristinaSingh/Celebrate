//
//  BundlesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import UIKit
import SnapKit
import Combine

class BundlesViewController: UIViewController {
    
    private let area:Area?
    private let day:Day?
    private let time:TimeSlot?
    private let occasions:[CelebrateOcassion]
    private let categories:[Category]
    private let budget:String
    private let subcategories:String
    private let viewModel:CelebrateViewModel
    private let inputs:[Input]
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var bundles:[AIBundle]{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    init(area: Area?, day: Day?, time: TimeSlot?, occasions: [CelebrateOcassion], categories: [Category], subcategories:String , budget: String, inputs:[Input]) {
        self.area = area
        self.day = day
        self.time = time
        self.occasions = occasions
        self.categories = categories
        self.budget = budget
        self.subcategories = subcategories
        self.viewModel = CelebrateViewModel()
        self.bundles = []
        self.inputs = inputs
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
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Celebration Bundles".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    lazy private var tableView:UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(BundleCell.self, forCellReuseIdentifier: "BundleCell")
        return table
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Bundles")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        headerView.back(vc: self)
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [headerView, tableView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
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
        
        viewModel.$bundles.receive(on: DispatchQueue.main).sink { bundles in
            guard let bundles = bundles?.bundles else {return}
            self.bundles = bundles
        }.store(in: &cancellables)
        
        var subCategoriesInputs: [SubCategoriesInput] = []
        self.inputs.forEachIndexed { _, input in
            let subCategoriesInput = SubCategoriesInput(subCategoryID: input.subCatId, type: input.type, contentType: input.contentType, value: input.value)
            subCategoriesInputs.append(subCategoriesInput)
        }
        let selectedCategoryIDs = self.categories
            .filter { category in
                category.subcategories.contains { $0.isSelected }
            }
            .compactMap { $0.id }
            .map { "\($0)" }
            .joined(separator: ",")
        let body = BundleBody(subCategoriesInputs: subCategoriesInputs.isEmpty ? nil : subCategoriesInputs, deliveryDate: DateFormatter.standard.string(from: self.day?.date ?? Date()), occassions: self.occasions.map({ occasion in occasion.id ?? ""}).joined(separator: ","), categories: selectedCategoryIDs, subcategories: self.subcategories, maxPrice: self.budget)
        viewModel.loadBundles(body: body)
    }
    
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
extension BundlesViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bundles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BundleCell") as! BundleCell
        cell.products = bundles[safe:indexPath.row]?.products ?? []
        cell.bundleIndex = indexPath.row
        cell.isHighlightedBundle = bundles[safe:indexPath.row]?.highlight == true
        cell.button.tap {
            guard let bundle = self.bundles[safe:indexPath.row] else { return }
            let vc = BundleItemsViewController(bundle: bundle, index: indexPath.row, area: self.area, day: self.day, time: self.time, occasions: self.occasions, categories: self.categories, budget: self.budget, subcategories: self.subcategories, inputs: self.inputs)
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bundles[safe:indexPath.row]?.highlight == true ? 304 : 284
    }
}
