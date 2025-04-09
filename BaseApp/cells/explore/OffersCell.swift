//
//  OffersCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class OffersCell: UITableViewCell {
    
    private var products: [Product] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private let top:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "offers_top")
        return img
    }()
    

    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return view
    }()
    
    private let bottom:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "offers_bottom")
        return img
    }()
    
    private let newLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.text = "NEW".localized
        return lbl
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .white
        lbl.text = "Explore our exclusive offers".localized
        return lbl
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    private let viewAllOffersTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.text = "View all offers".localized
        return lbl
    }()
    
    
    private let viewAllBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "forward_btn"), for: .normal)
        return btn
    }()
    
    var delegate:ExploreActions?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        [top , containerView , bottom].forEach { view in
            self.contentView.addSubview(view)
        }
        
        top.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.top.snp.bottom)
            make.bottom.equalTo(self.bottom.snp.top)
        }
        
        bottom.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        
        [newLbl , titleLbl , collectionView , viewAllOffersTitleLbl , viewAllBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        newLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.newLbl.snp.bottom).offset(4)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
            make.bottom.equalTo(self.viewAllOffersTitleLbl.snp.top).offset(-24)
        }
        
        viewAllOffersTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        viewAllBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.viewAllOffersTitleLbl.snp.centerY)
            make.leading.equalTo(self.viewAllOffersTitleLbl.snp.trailing).offset(8)
        }
        
        viewAllBtn.tap {
            self.delegate?.viewAllOffers()
        }
    }
    
    func show(products: [Product], delegate:ExploreActions?) {
        self.products = products
        self.delegate = delegate
    }
}
extension OffersCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = products.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 289.constraintMultiplierTargetValue.relativeToIphone8Height())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = products.get(at: indexPath.row) else {return}
        self.delegate?.show(product: product)
    }
    
}

