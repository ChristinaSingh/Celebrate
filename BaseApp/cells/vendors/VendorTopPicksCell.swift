//
//  VendorTopPicksCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit
import SnapKit

class VendorTopPicksCell: UICollectionViewCell {
    
    private var products: [Product] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "top_picks")
        return icon
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.text = "Top picks".localized
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
    
    var withoutBackground: Bool = false
    var callback:((Product) -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        [icon , titleLbl  , collectionView].forEach { view in
            self.contentView.addSubview(view)
        }
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
            make.centerY.equalTo(self.icon.snp.centerY)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(17)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func show(products: [Product]) {
        self.products = products
    }
    
}
extension VendorTopPicksCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.withoutBackground = self.withoutBackground
        cell.product = products.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 273.constraintMultiplierTargetValue.relativeToIphone8Height())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = products.get(at: indexPath.row){
            self.callback?(product)
        }
    }
}
