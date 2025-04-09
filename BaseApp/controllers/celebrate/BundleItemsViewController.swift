//
//  BundleItemsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 08/11/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class BundleItemsViewController: UIViewController {
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:CelebrateViewModel
    private let bundle:AIBundle
    private let index:Int
    private let area:Area?
    private let day:Day?
    private let time:TimeSlot?
    private let occasions:[CelebrateOcassion]
    private let categories:[Category]
    private let budget:String
    private let subcategories:String
    private let inputs:[Input]
    
    init(bundle: AIBundle, index:Int, area:Area?, day:Day?, time:TimeSlot?, occasions:[CelebrateOcassion], categories:[Category], budget:String, subcategories:String, inputs:[Input]) {
        self.bundle = bundle
        self.index = index
        self.area = area
        self.day = day
        self.time = time
        self.occasions = occasions
        self.categories = categories
        self.budget = budget
        self.subcategories = subcategories
        self.inputs = inputs
        self.viewModel = CelebrateViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy private var headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "\("Celebration Bundle".localized) \(index + 1)".capitalized)
        view.backgroundColor = .white
        return view
    }()
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private lazy var productsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell" )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    
    private let addToCartCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    lazy private var addToCartBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Add all to cart".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
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
        
        [headerView, productsCollectionView, addToCartCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        productsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.addToCartCardView.snp.top)
        }
        
        addToCartCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        [addToCartBtn].forEach { view in
            self.addToCartCardView.addSubview(view)
        }
        
        addToCartBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.leading.top.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            self.addToCartBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$options.dropFirst().receive(on: DispatchQueue.main).sink { res in
            guard let options = res?.products else {return}
            let vc = BundleItemsOptionsViewController(products: options, area: self.area, day: self.day, time: self.time, occasions: self.occasions, categories: self.categories, budget: self.budget, subcategories: self.subcategories, inputs: self.inputs)
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }.store(in: &cancellables)
        
        actions()
    }
    
    
    func actions(){
        addToCartBtn.tap = {
            self.viewModel.getOptions(bundleItems: self.bundle.products?.map{ $0.id ?? "" }.joined(separator: ",") ?? "")
        }
    }
}

extension BundleItemsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bundle.products?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = bundle.products?.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 24) / 2, height: 289.constraintMultiplierTargetValue.relativeToIphone8Height())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = bundle.products?.get(at: indexPath.row) else { return }
        let vc = ProductDetailsViewController(product: product,date: DateFormatter.standard.string(from: self.day?.date ?? Date()), locationId: self.area?.id , cartType: .ai, cartTime: self.time?.displaytime)
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
    
}
