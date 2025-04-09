//
//  ProductDetailsBannerCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit

class ProductDetailsBannerCell: UITableViewCell {
    
    private lazy var collectionView:UICollectionView = {
        let layout = YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 16)
        var animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0, sideItemAlpha: 0, sideItemShift: 0.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 360)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl:UIPageControl = {
        let page = UIPageControl()
        page.tintColor = .accent.withAlphaComponent(0.25)
        page.pageIndicatorTintColor = .accent.withAlphaComponent(0.25)
        page.currentPageIndicatorTintColor = .accent
        return page
    }()
    
    var defaultImg:ExtraImage?{
        didSet{
            guard let defaultImg = defaultImg else{return}
            if extraImages == nil{
                self.extraImages = []
            }
            self.extraImages?.insert(defaultImg, at: 0)
        }
    }
    
    var extraImages: [ExtraImage]?{
        didSet{
            collectionView.reloadData()
            self.pageControl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            self.pageControl.numberOfPages = extraImages?.count ?? 0
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
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(collectionView)
        self.contentView.addSubview(pageControl)
        self.collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.collectionView.snp.bottom).offset(-16)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl()
    }
    
    
    func updatePageControl() {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pageControl.currentPage = indexPath.item
    }
}
extension ProductDetailsBannerCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extraImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as! BannerImageCell
        let index = indexPath.row
        cell.image.contentMode = .scaleAspectFill
        cell.border = 1
        if let banner = extraImages?.get(at: index){
            if let url = banner.url{
                cell.imageUrl = url
            }else{
                cell.imageUrl = "https://res.cloudinary.com/ypakawala/image/upload/\(banner.cloudinaryUUID ?? "")"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        previewImg(index: indexPath.row)
    }
    
    private func previewImg(index:Int){
        PreviewerViewController.show(extraImages?.map({ img in
            if let url = img.url{
                url
            }else{
                "https://res.cloudinary.com/ypakawala/image/upload/\(img.cloudinaryUUID ?? "")"
            }
        }) ?? [], selectedIndex: index)
    }
}
