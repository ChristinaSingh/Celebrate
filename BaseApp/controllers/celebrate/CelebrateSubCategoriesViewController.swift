//
//  CelebrateSubCategoriesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/09/2024.
//

import UIKit
import SnapKit
import Combine

class CelebrateSubCategoriesViewController: UIViewController {
    
    
    private let category:Category
    private let occasions:[CelebrateOcassion]
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:CelebrateViewModel
    private var collectionHeightConstraint: Constraint?
    private var subcategories:[Category]{
        didSet{
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            let maxTableHeight = proceedCardView.frame.minY - 20
            let tableContentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            let finalHeight = min(tableContentHeight, maxTableHeight)
            collectionHeightConstraint?.update(offset: finalHeight)
            self.view.layoutIfNeeded()
            //self.proceedBtn.enableDisableSaveButton(isEnable: self.subcategories.filter({ category in category.isSelected}).count > 0)
        }
    }
    init(category: Category, occasions:[CelebrateOcassion]) {
        self.category = category
        self.occasions = occasions
        self.subcategories = []
        self.viewModel = CelebrateViewModel()
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
        let view = HeaderViewWithCancelButton(title: "")
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = CenteredFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubCategoryCell.self, forCellWithReuseIdentifier: "SubCategoryCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
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
        let btn = LoadingButton.createObject(title: "Done".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "SubCategories")
        return view
    }()
    
    
    
    var callback:(([Category]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.titleLbl.text = AppLanguage.isArabic() ? category.arName : category.name
        self.headerView.cancel(vc: self)
        
        [headerView, collectionView, proceedCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        
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
            make.height.equalTo(58)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualTo(self.proceedCardView.snp.top)
            self.collectionHeightConstraint = make.height.equalTo(48).constraint
        }
        
        proceedBtn.tap = {
            self.dismiss(animated: true) {
                self.callback?(self.subcategories.filter({ category in category.isSelected }))
            }
        }
        
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
                
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.viewModel.$subcategories.receive(on: DispatchQueue.main).sink { subcategories in
            if var subcategories = subcategories?.data {
                subcategories.forEachIndexed { index, _subcategory in
                    if self.category.subcategories.contains(where: { category in
                        category.id == _subcategory.id
                    }){
                        subcategories[safe: index]?.isSelected = true
                    }
                }
                self.subcategories = subcategories
            }
        }.store(in: &cancellables)
        
        self.viewModel.loadsubCategories(occasions: self.occasions.map({ occasion in occasion.id ?? ""}).joined(separator: ","), categories: self.category.id ?? "")
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
extension CelebrateSubCategoriesViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        cell.isCelebrate = true
        cell.category = self.subcategories[safe: indexPath.row]
        cell.layoutMargins = .zero
        cell.containerView.layer.borderColor = UIColor.clear.cgColor
        cell.containerView.layer.cornerRadius = 24
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let category = subcategories.get(at: indexPath.row){
            let width =  if AppLanguage.isArabic() {
                category.arName?.width(withConstrainedHeight: 32, font: (AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12))!) ?? 100
            }else{
                category.name?.width(withConstrainedHeight: 32, font: (AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12))!) ?? 100
            }
            return CGSize(width: width + 24, height: 48)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.subcategories.get(at: indexPath.row)?.isSelected == true {
            self.subcategories[safe:indexPath.row]?.isSelected = false
        }else{
            self.subcategories[safe:indexPath.row]?.isSelected = true
        }
    }

}
