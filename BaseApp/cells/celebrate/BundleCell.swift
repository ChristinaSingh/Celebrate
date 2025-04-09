//
//  BundleCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import Foundation
import SnapKit
import UIKit


class BundleCell:UITableViewCell{
    
    
    private let cardView:CardView = {
       let cardView = CardView()
        cardView.backgroundColor = .white
        cardView.cornerRadius = 12
        cardView.shadowOpacity = 1
        cardView.shadowOffsetHeight = 12
        cardView.shadowOffsetWidth = 0
        cardView.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        cardView.clipsToBounds = true
        return cardView
    }()
    
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    private let descLbl:C8Label = {
        let lbl = C8Label()
        lbl.numberOfLines = 2
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    lazy private var productsCV:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BundleProductCell.self, forCellWithReuseIdentifier: "BundleProductCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let summeryView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
        return view
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    let button:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 16.constraintMultiplierTargetValue.relativeToIphone8Height()
        btn.setTitleColor(.black, for: .normal)
        btn.alpha = 1
        btn.setTitle("BUY NOW".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.backgroundColor = UIColor.accent.cgColor
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        return btn
    }()
    
    
    private let recommendedLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .white
        lbl.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        lbl.backgroundColor = .recommended
        lbl.text = "RECOMMENDED".localized
        return lbl
    }()
    
    var bundleIndex:Int = 0 {
        didSet{
            self.titleLbl.text = "\("Celebration Bundle".localized) \(Double(bundleIndex + 1).clean)"
        }
    }
    
    
    var isHighlightedBundle:Bool = false {
        didSet{
            self.cardView.backgroundColor = isHighlightedBundle ? .primary : .white
            self.summeryView.backgroundColor = isHighlightedBundle ? .white : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
            self.descLbl.textColor = isHighlightedBundle ? .secondary : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
            self.titleLbl.textColor = isHighlightedBundle ? .white : .black
            if isHighlightedBundle {
                self.recommendedLbl.isHidden = false
                self.recommendedLbl.snp.remakeConstraints { make in
                    make.leading.top.equalToSuperview().inset(16)
                    make.height.equalTo(20)
                }
            }else{
                self.recommendedLbl.isHidden = true
                self.recommendedLbl.snp.remakeConstraints { make in
                    make.leading.top.equalToSuperview().inset(16)
                    make.height.equalTo(0)
                }
            }
        }
    }
    
    var products:[Product] = []{
        didSet{
            self.productsCV.reloadData()
            self.descLbl.text = "\("We’ve curated and prepared a special bundle with".localized) \(products.count) \("products for your celebration".localized)"
            let price = products.map { bundle in
                bundle.price?.toDouble() ?? 0.0
            }.reduce(0, +)
            self.priceLbl.text = "\(price.clean) \("kd".localized)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(cardView)
        self.cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        [recommendedLbl, titleLbl, descLbl, productsCV, summeryView].forEach { view in
            self.cardView.addSubview(view)
        }
        
        [priceLbl, button].forEach { view in
            self.summeryView.addSubview(view)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(99)
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        recommendedLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(self.recommendedLbl.snp.bottom)
            make.height.equalTo(36)
        }
        
        descLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.titleLbl.snp.bottom)
            make.height.equalTo(44)
        }
        
        productsCV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(64)
            make.top.equalTo(self.descLbl.snp.bottom).offset(16)
        }
        
        summeryView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.productsCV.snp.bottom).offset(16)
            make.height.equalTo(64)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension BundleCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BundleProductCell", for: indexPath) as! BundleProductCell
        cell.product = self.products[safe: indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
