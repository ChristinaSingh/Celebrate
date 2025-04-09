//
//  VendorProductsHeaderView.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit
import SnapKit

class VendorProductsHeaderView: UICollectionReusableView {
 
    var categories:[Category] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    let filterContainerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.text = "Filter".localized
        return lbl
    }()
    
    
    private let img:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "filter_icon")
        icon.tintColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return icon
    }()
    
    private let filterArrow:UIButton = {
        let icon = UIButton()
        icon.setImage(UIImage(named: "filter_arrow"), for: .normal)
        icon.setImage(UIImage(systemName: "multiply"), for: .selected)
        icon.tintColor = .white
        icon.isUserInteractionEnabled = false
        return icon
    }()
    
    
    private let filterBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let containerView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubCategoryCell.self, forCellWithReuseIdentifier: "SubCategoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    var isCelebrate:Bool = false
    
    var isFilterApplied:Bool = false {
        didSet {
            if isFilterApplied {
                img.tintColor = .white
                titleLbl.textColor = .white
                filterContainerView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                filterArrow.isSelected = true
                filterArrow.isUserInteractionEnabled = true
                filterArrow.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-8)
                    make.centerY.equalToSuperview()
                }
            }else{
                titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
                filterContainerView.backgroundColor = .clear
                filterArrow.isSelected = false
                img.tintColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                filterArrow.isUserInteractionEnabled = false
                filterArrow.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-12)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
    var subCategoryDidSelect:((Category?) -> Void)?
    var filterDidTapped:(() -> Void)?
    var clearDidTapped:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(collectionView)
        self.containerView.addSubview(filterContainerView)
        filterContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(89)
            make.height.equalTo(32)
        }
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(self.filterContainerView.snp.trailing).offset(12)
            make.height.equalTo(32)
        }
        
        [img , titleLbl, filterBtn , filterArrow].forEach { view in
            self.filterContainerView.addSubview(view)
        }
        
        img.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.img.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        filterArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        filterBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterBtn.tap {
            self.filterDidTapped?()
        }
        
        filterArrow.tap {
            self.clearDidTapped?()
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(categories:[Category]) {
        self.categories = categories
        if collectionView.numberOfItems(inSection: 0) > 0, let index = self.categories.firstIndex(where: { cat in
            cat.isSelected
        }) {
            let firstIndexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}
extension VendorProductsHeaderView:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        cell.isCelebrate = self.isCelebrate
        cell.category = categories.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let category = categories.get(at: indexPath.row){
           let width =  if AppLanguage.isArabic() {
               category.arName?.width(withConstrainedHeight: 32, font: (AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12))!) ?? 100
            }else{
                category.name?.width(withConstrainedHeight: 32, font: (AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12))!) ?? 100
            }
            return CGSize(width: width + 24, height: 32)
        }
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resetSelection()
        self.categories[safe: indexPath.row]?.isSelected = true
        self.collectionView.reloadData()
        self.subCategoryDidSelect?(self.categories.get(at: indexPath.row))
    }
    
    
    private func resetSelection(){
        for (index , _) in self.categories.enumerated() {
            self.categories[safe: index]?.isSelected = false
        }
    }
    
}

