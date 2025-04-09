//
//  ProductCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.contentInset = .zero
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        collectionView.register(ProductSliderCell.self, forCellWithReuseIdentifier: "ProductSliderCell")
        return collectionView
    }()
    
    
    private let imagesIndicator:UIPageControl = {
        let indicator = UIPageControl()
        indicator.currentPageIndicatorTintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        indicator.pageIndicatorTintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return indicator
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.numberOfLines = 2
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return lbl
    }()
    
    
    lazy private var pricePerSelectionView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.layer.cornerRadius = 12
        view.addSubview(pricePerSelectionLbl)
        pricePerSelectionLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    private let pricePerSelectionLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 9)
        lbl.textColor = .white
        lbl.text = "Price per selection".localized
        return lbl
    }()
    
    
    private let prevLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    private let badgeView:OfferBadge = {
        let view = OfferBadge(frame: .zero)
        return view
    }()
    
    private let blurrView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    lazy private var productStatusView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(statusLbl)
        statusLbl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    
    let addBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.accent.cgColor
        btn.clipsToBounds = true
        btn.setTitle("ADD".localized)
        btn.setTitleColor(.accent, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        return btn
    }()
    
    private let statusIcon:UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    
    private let statusLbl:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 8)
        return lbl
    }()
    
    private var images:[String?] = []{
        didSet{
            imagesIndicator.numberOfPages = images.count > 1 ? images.count : 0
            imagesIndicator.currentPage = 0
            titleLbl.snp.updateConstraints { make in
                make.top.equalTo(self.imagesIndicator.snp.bottom).offset(images.count > 1 ? 3 : 16)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            CATransaction.commit()
        }
    }
    
    let favoriteBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "heart_unselected"), for: .normal)
        btn.setImage(UIImage(named: "selected_heart"), for: .selected)
        return btn
    }()
    
    var product:Product?{
        didSet{
            guard let product = product else{return}
            pricePerSelectionView.isHidden = true
            priceLbl.isHidden = false
            self.favoriteBtn.isSelected = product.isFav == 1
            if let offerPrice = product.offerPrice , let offerPercent = product.offerPercent {
                prevLbl.addStroke(product.price?.formatPrice() ?? "")
                priceLbl.text = offerPrice.formatPrice()
                badgeView.offer = offerPercent
                prevLbl.isHidden = false
                badgeView.isHidden = false
            }else{
                if product.isOffer == true {
                    priceLbl.text = product.offerdetails?.offerPrice?.formatPrice() ?? ""
                    prevLbl.addStroke(product.price?.formatPrice() ?? "")
                }else{
                    if let priceDouble = Double(product.price ?? "0.0"), priceDouble <= 0.0 {
                        pricePerSelectionView.isHidden = false
                        priceLbl.isHidden = true
                    }else{
                        pricePerSelectionView.isHidden = true
                        priceLbl.isHidden = false
                    }
                    priceLbl.text = product.price?.formatPrice()
                    prevLbl.addStroke(product.offerdetails?.offerPrice?.formatPrice() ?? "")
                }
                badgeView.offer = product.offerdetails?.offerPercent
                prevLbl.isHidden = !(product.isOffer == true)
                badgeView.isHidden = !(product.isOffer == true)
            }
            titleLbl.text = AppLanguage.isArabic() ? product.arName : product.name
            images = [product.imageURL]
            
            if let tuple = self.productState(product: product), let icon = tuple.icon, let title = tuple.title, let backgroundColor = tuple.backgroundColor {
                self.productStatusView.isHidden = false
                self.statusIcon.image = icon
                self.statusLbl.text = title
                self.productStatusView.backgroundColor = backgroundColor
                self.productStatusView.snp.updateConstraints { make in
                    make.width.equalTo(title.width(withConstrainedHeight: 24, font: AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 8)!) + 20)
                }
            }else{
                self.productStatusView.isHidden = true
                self.statusIcon.image = nil
                self.statusLbl.text = nil
                self.productStatusView.backgroundColor = .clear
            }
        }
    }
    
    var withoutBackground: Bool = false {
        didSet {
            self.containerView.backgroundColor = withoutBackground ? .clear : .white
            self.collectionView.backgroundColor = withoutBackground ? .white : .clear
            self.containerView.layer.borderWidth = withoutBackground ? 0 : 1
            self.collectionView.layer.borderWidth = withoutBackground ? 1 : 0
            self.collectionView.layer.cornerRadius = withoutBackground ? 8 : 0
            self.collectionView.layer.borderColor = withoutBackground ? UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor : UIColor.clear.cgColor
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [collectionView, favoriteBtn ,badgeView , imagesIndicator , titleLbl , priceLbl , pricePerSelectionView, productStatusView , prevLbl, addBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(169.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        favoriteBtn.isHidden = true
        favoriteBtn.isUserInteractionEnabled = false
        favoriteBtn.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        badgeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(24)
            make.height.equalTo(27)
        }
        
        imagesIndicator.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
        
        imagesIndicator.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(32)
            make.top.equalTo(self.collectionView.snp.bottom)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(self.imagesIndicator.snp.bottom).offset(3)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(6)
        }
        pricePerSelectionView.isHidden = true
        pricePerSelectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(6)
            make.width.equalTo(100)
            make.height.equalTo(24)
        }
        
        prevLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.priceLbl.snp.trailing).offset(4)
            make.centerY.equalTo(self.priceLbl.snp.centerY)
        }
        
        addBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(59)
            make.height.equalTo(32)
        }
        
        productStatusView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalTo(self.priceLbl.snp.bottom).offset(6)
            make.height.equalTo(24)
            make.width.equalTo(0)
        }
        
    }
    
    override func prepareForReuse() {
        prevLbl.text = nil
        titleLbl.text = nil
        priceLbl.text = nil
    }
    
    
    private func productState(product:Product) -> (icon:UIImage?, title:String? , backgroundColor:UIColor?)?{
        if product.prepTimeNotAvailable == true {
            return (UIImage(named: "time") , "Requires more time to prepare".localized , UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1))
        }
        
        if let isLocationAvailable = product.isLocationAvailable, !isLocationAvailable {
            return (UIImage(named: "serve_area") , "Not available in selected area".localized , UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        }
        
        if let isResourceAvailable = product.isResourceAvailable, !isResourceAvailable {
            return (UIImage(named: "full_booked") , "Currently fully booked".localized , UIColor(red: 1, green: 0.22, blue: 0.502, alpha: 1))
        }
        
        if let requiresApproval = product.requiresApproval, requiresApproval {
            return (UIImage(named: "pay_upon_approval") , "Pay upon approval".localized , UIColor(red: 1, green: 0.518, blue: 0.333, alpha: 1))
        }
        
        return (nil, nil, nil)
    }
    
}
extension ProductCell:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSliderCell", for: indexPath) as! ProductSliderCell
        cell.imgURL = images.get(at: indexPath.row) ?? ""
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
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
        imagesIndicator.currentPage = indexPath.item
    }
}
