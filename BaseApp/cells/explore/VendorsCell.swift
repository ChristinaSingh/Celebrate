//
//  VendorsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import UIKit
import SnapKit

class VendorsCell: UITableViewCell {
    private var vendors : [Vendor]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    private var delegate:ExploreActions?
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return view
    }()
    
    
    private let brandsLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.text = "100+ BRANDS".localized
        return lbl
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .white
        lbl.text = "Explore our service providers".localized
        return lbl
    }()
    
    
    private let viewAllCompaniesTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.text = "View all companies".localized
        return lbl
    }()
    
    
    private let viewAllBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "forward_btn"), for: .normal)
        return btn
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = createLayout(row: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(VendorItemCell.self, forCellWithReuseIdentifier: "VendorItemCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    private func createLayout(row:Int) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let spaces = 16 * row
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(row * 100) + CGFloat(spaces)), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
   

    
    func showVendors(vendors : [Vendor]? , delegate:ExploreActions?){
        let rowCount = CGFloat(vendors?.count ?? 0) / 2.0
        self.collectionView.collectionViewLayout = createLayout(row: Int(rowCount.rounded(.up)))
        self.vendors = vendors
        self.delegate = delegate
    }
    
    
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
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }
        
        [brandsLbl , titleLbl , collectionView, viewAllCompaniesTitleLbl , viewAllBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        brandsLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.brandsLbl.snp.bottom).offset(4)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
            make.height.equalTo(256)
        }
        
        viewAllCompaniesTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        viewAllBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.viewAllCompaniesTitleLbl.snp.centerY)
            make.leading.equalTo(self.viewAllCompaniesTitleLbl.snp.trailing).offset(8)
        }
        
        viewAllBtn.tap {
            self.delegate?.viewAllCompanies()
        }
    }
    
    
}
extension VendorsCell:UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorItemCell", for: indexPath) as! VendorItemCell
        if let vendor = vendors?.get(at: indexPath.row){
            cell.vendor = vendor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vendor = vendors?.get(at: indexPath.row){
            self.delegate?.show(vendor: vendor)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }
}
