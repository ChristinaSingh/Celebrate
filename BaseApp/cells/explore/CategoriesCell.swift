//
//  CategoriesCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import UIKit
import SnapKit

class CategoriesCell: UITableViewCell {
    
    private var delegate:ExploreActions?
    private var categories : [Category]? {
        didSet{
            self.collectionView.reloadData()
        }
    }

    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        return view
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .black
        lbl.text = "Browse through 5000+ products".localized
        return lbl
    }()
    
    
    private lazy var collectionView:UICollectionView = {
        let layout = createLayout(row: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryItemCell.self, forCellWithReuseIdentifier: "CategoryItemCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    
    private func createLayout(row:Int) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(128))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let spaces = 24 * row
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(row * 80) + CGFloat(spaces)), heightDimension: .absolute(128))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(24)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        [titleLbl , collectionView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    func showCategoreis(categories : [Category]?, delegate:ExploreActions?){
        let rowCount = CGFloat(categories?.count ?? 0) / 2.0
        self.collectionView.collectionViewLayout = createLayout(row: Int(rowCount.rounded(.up)))
        self.categories = categories
        self.delegate = delegate
    }
    

}
extension CategoriesCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as! CategoryItemCell
        if let category = categories?.get(at: indexPath.row) {
            cell.category = category
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = self.categories?.get(at: indexPath.row){
            self.delegate?.show(category: category)
        }
    }
}
