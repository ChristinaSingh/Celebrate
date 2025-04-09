//
//  BundleItemsOptionsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/12/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class BundleItemsOptionsViewController: UIViewController, BundleItemsOptionsCellDelegate {
    
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:CelebrateViewModel
    private let products: [ProductDetails]
    private let area:Area?
    private let day:Day?
    private let time:TimeSlot?
    private let occasions:[CelebrateOcassion]
    private let categories:[Category]
    private let budget:String
    private let subcategories:String
    private let inputs:[Input]
    
    init(products: [ProductDetails], area:Area?, day:Day?, time:TimeSlot?, occasions:[CelebrateOcassion], categories:[Category], budget:String, subcategories:String, inputs:[Input]) {
        self.products = products.filter({ product in
            product.options?.isEmpty == false
        })
        self.area = area
        self.day = day
        self.time = time
        self.occasions = occasions
        self.categories = categories
        self.inputs = inputs
        self.budget = budget
        self.subcategories = subcategories
        viewModel = CelebrateViewModel()
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
        let view = HeaderViewWithCancelButton(title: "Please choose your selections".capitalized)
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy private var tableView: ContentFittingTableView = {
        let table = ContentFittingTableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = UITableView.automaticDimension
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.register(BundleItemsOptionsCell.self, forCellReuseIdentifier: BundleItemsOptionsCell.identifier)
        table.register(OptionProductDetailsHeader.self, forHeaderFooterViewReuseIdentifier: OptionProductDetailsHeader.identifier)
        return table
    }()
    
    
    private let doneView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    lazy private var doneBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Done".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        
        [headerView, tableView, doneView].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.doneView.snp.top)
        }
        
        doneView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        [doneBtn].forEach { view in
            self.doneView.addSubview(view)
        }
        
        doneBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.leading.top.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        viewModel.$cartDeleted.receive(on: DispatchQueue.main).sink { deletedCart in
            if let _ = deletedCart {
                self.proceed()
            }
        }.store(in: &cancellables)
        
        viewModel.$expiredCart.receive(on: DispatchQueue.main).sink { expiredCart in
            if let expiredCart = expiredCart {
                self.cartExpired(cart: expiredCart)
            }
        }.store(in: &cancellables)
        
        self.viewModel.$addedItemToCart.receive(on: DispatchQueue.main).sink { item in
            guard item != nil else {return}
            let vc = CartViewController()
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            self.doneBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        viewModel.$error
            .combineLatest(viewModel.$error)
            .receive(on: DispatchQueue.main)
            .sink {  productError, cartError in
                if let error = productError ?? cartError {
                    if let error = error as? CartError {
                        let vc = RecreateCartViewController(cartViewModel: CartViewModel(), error: error)
                        vc.callback = {
                            self.proceed()
                        }
                        SheetPresenter.shared.presentSheet(vc, on: self, height: 300, isCancellable: false)
                    }else{
                        MainHelper.handleApiError(error)
                    }
                }
            }
            .store(in: &cancellables)
        
        actions()
        self.tableView.layoutSubviews()
    }
    
    
    func actions(){
        doneBtn.tap = {
            self.proceed()
        }
    }
    
    func createBody(productDetails: ProductDetails?, index:Int) -> CartBody?{
        guard let product = productDetails else {
            //TODO:- show invlaid product toast
            return nil
        }
        let tuple = ProductHandler.isvalidSelections(product: product)
        if let section = tuple.section {
            if let cell = self.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: index)) as? BundleItemsOptionsCell {
                self.products[safe: index]?.isItemExpanded = true
                self.tableView.reloadData()
                self.tableView.performBatchUpdates({
                    self.scrollToSection(index, tableView: self.tableView)
                    let innerTableView = cell.tableView
                    innerTableView.performBatchUpdates({
                        self.scrollToSection(section, tableView: innerTableView)
                    })
                })
            }
            ToastBanner.shared.show(message: tuple.message ?? "", style: .info, position: .Top)
            return nil
        }
        
        return ProductHandler.createCartBody(product: product, date: DateFormatter.standard.string(from: self.day?.date ?? Date()), location: self.area?.id, timeSlotID: time?.displaytime ?? "", selections: tuple.selections, addressid: nil, cartTime: time?.displaytime ?? "", friendID: nil)
        
    }
    
    func proceed(){
        var body:[CartBody] = []
        self.products.forEachIndexed{ index, product in
            
            if let item = self.createBody(productDetails: product, index: index){
                body.append(item)
            }else{
                return
            }
        }
        if body.count < self.products.count{
            return
        }
        print(body.convertToString ?? "")
        self.viewModel.addIBundleToCart(items: body, locationId: self.area?.id ?? "", date: DateFormatter.standard.string(from: self.day?.date ?? Date()), time: self.time?.displaytime ?? "", cartType: .ai, cartTime: time?.displaytime)
    }
    
    private func scrollToSection(_ section:Int, tableView:UITableView){
        let headerRect = tableView.rectForHeader(inSection: section)
        tableView.scrollRectToVisible(headerRect, animated: true)
    }
    
    private func cartExpired(cart:Cart){
        let vc = ExpiredViewController(titleStr: "Cart has been expired".localized, message: "Your cart has been expired and it's products will be deleted, By proceeding we will create new cart.".localized) {
            self.viewModel.deleteCart(id: cart.id ?? "")
        }
        SheetPresenter.shared.presentSheet(vc, on: self, height: 234, isCancellable: false)
    }
    
    func didUpdateHeight() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
}


extension BundleItemsOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products[safe: section]?.isItemExpanded == true ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BundleItemsOptionsCell.identifier) as! BundleItemsOptionsCell
        cell.productDetails = products[safe: indexPath.section]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: OptionProductDetailsHeader.identifier) as? OptionProductDetailsHeader
        header?.productDetails = products[safe: section]
        header?.isItemExpanded = products[safe: section]?.isItemExpanded
        header?.actionBtn.tap {
            self.products[safe: section]?.isItemExpanded.toggle()
            tableView.reloadData()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}


final class ContentFittingTableView: UITableView {
    
    // MARK: - Override Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: self.contentSize.width, height: self.contentSize.height)
    }
    
    override var contentSize: CGSize {
        didSet {
            // Trigger intrinsicContentSize recalculation
            invalidateIntrinsicContentSize()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Trigger the intrinsic content size update
        invalidateIntrinsicContentSize()
    }
}

final class ContentSizedCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
