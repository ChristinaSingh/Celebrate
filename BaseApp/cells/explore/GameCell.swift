//
//  GameCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import UIKit
import SnapKit

class GameCell: UITableViewCell {
    
    private lazy var collectionView:UICollectionView = {
        let layout = YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 16)
        var animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0, sideItemAlpha: 0, sideItemShift: 0.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 186)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var delegate:ExploreActions?
    
    private var banners:Banners = []{
        didSet{
            self.collectionView.reloadData()
        }
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
        self.contentView.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(186)
        }
    }
    
    func showBanners(banners:Banners, delegate:ExploreActions?) {
        self.banners = banners
        self.delegate = delegate
    }
    
}
extension GameCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as! BannerImageCell
        let index = indexPath.row
        if let banner = banners.get(at: index){
            cell.imageUrl = banner.imageURL
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let banner = self.banners[safe: indexPath.row] else {return}
        self.delegate?.show(banner: banner)
    }
}
