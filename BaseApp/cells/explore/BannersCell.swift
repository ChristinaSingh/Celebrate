//
//  BannersCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//

import UIKit
import SnapKit

class BannersCell: UITableViewCell {
    
    private lazy var collectionView:CarouselCollectionView = {
        let layout = AppLanguage.isArabic() ? RTLYZCenterFlowLayout() : YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 16)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 200)
        let collectionView = CarouselCollectionView(frame: .zero, collectionViewFlowLayout: layout)
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.carouselDataSource = self
        collectionView.autoscrollTimeInterval = 3.0
        collectionView.isAutoscrollEnabled = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    let pageControl:UIPageControl = {
        let page = UIPageControl()
        page.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        page.pageIndicatorTintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        page.currentPageIndicatorTintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return page
    }()
    
    
    
    private var banners:Banners = []{
        didSet{
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.banners.count
        }
    }
    
    private var delegate:ExploreActions?
    
   
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
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(200)
        }
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom).offset(16)
            make.width.equalTo(150)
        }
    }
    
    
    func showBanners(banners:Banners, delegate:ExploreActions?) {
        self.banners = banners
        collectionView.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        pageControl.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        self.delegate = delegate
    }
}



extension BannersCell: CarouselCollectionViewDataSource{
    var numberOfItems: Int {
        banners.count
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: fakeIndexPath) as! BannerImageCell
        if let banner = banners.get(at: index){
            cell.imageUrl = AppLanguage.isArabic() ? banner.imageUrlAr : banner.imageURL
        }
        return cell
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didSelectItemAt index: Int) {
        guard let banner = self.banners[safe: index] else {return}
        self.delegate?.show(banner: banner)
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
    }

}
enum BannerType{
    case VENDOR
    case URL
    case ITEM
    case CATEGORY
    case CORPORATE
    case GAME
    
    var type: String {
        switch self {
        case .ITEM:
            return "ITEM"
        case .URL:
            return "URL"
        case .VENDOR:
            return "VENDOR"
        case .CATEGORY:
            return "CATEGORY"
        case .CORPORATE:
            return "CORPORATE"
        case .GAME:
            return "GAME"
            
            
        }
    }
}

