//
//  NewArrivalsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

enum NewArrivalsType {
    case NewArrivals
    case TopPicks
}

class NewArrivalsCell: UITableViewCell {
    
    private var products: [Product] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.text = "New arrivals".localized
        return lbl
    }()
    
    
    private let viewAllBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("see all".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var delegate:ExploreActions?
    private var type:NewArrivalsType = .NewArrivals
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
        [titleLbl , viewAllBtn , collectionView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
        }
        
        viewAllBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.titleLbl.snp.centerY)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
        }
        
        viewAllBtn.tap {
            switch self.type {
            case .NewArrivals:
                self.delegate?.viewAllNewArrivals()
                break
            case .TopPicks:
                self.delegate?.viewAllTopPicks()
            }
            
        }
    }
    
    
    func show(products: [Product] , type:NewArrivalsType = .NewArrivals, delegate:ExploreActions?) {
        self.type = type
        switch type {
        case .NewArrivals:
            titleLbl.text = "New arrivals".localized
        case .TopPicks:
            titleLbl.text = "Top picks by our team".localized
        }
        self.delegate = delegate
        self.products = products
    }
}
extension NewArrivalsCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = products.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 289)
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
