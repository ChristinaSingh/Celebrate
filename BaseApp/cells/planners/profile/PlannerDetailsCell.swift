//
//  PlannerDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/06/2024.
//

import UIKit
import SnapKit

class PlannerDetailsCell: UITableViewCell {

    private let contenainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()

    private let plannerImg:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 32
        return img
    }()
    
    
    private let plannerNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .DINP, fontWeight: .regular, size: 14)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    private let plannerShortDescLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .DINP, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.text = "FAA Luxury Planners".localized
        return lbl
    }()
    
    
    private let rateIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "rate_icon")
        return img
    }()
    
    
    private let rateLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .DINP, fontWeight: .medium, size: 12)
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    
    private let rateView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    
    private let tagsView:TagsView = {
        let view = TagsView(frame: .zero, tags: [])
        return view
    }()
    
    
    
    var profile:PlannerProfileElement?{
        didSet{
            guard let planner = profile else {return}
            plannerImg.download(imagePath: planner.iconURL ?? "", size: CGSize(width: 64, height: 64))
            plannerNameLbl.text = AppLanguage.isArabic() ? planner.nameAr : planner.name
            rateLbl.text = planner.rating
            let tags = planner.specialities?.map{ (speciality) -> (icon: String?, text: String) in
                (speciality.imageURL , AppLanguage.isArabic() ? speciality.nameAr ?? "" : speciality.name ?? "")
            } ?? []
            self.tagsView.setTags(tags: tags)
            self.layoutIfNeeded()
//            self.tagsView.snp.updateConstraints { make in
//                make.height.equalTo(self.tagsView.collectionView.calculateExactHeight(itemHeight: 32, minimumLineSpacing: 10, sectionInset: .zero))
//            }
        }
    }

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(contenainerView)
        contenainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [plannerImg,/* plannerNameLbl, plannerShortDescLbl, rateView,*/ tagsView].forEach { view in
            self.contenainerView.addSubview(view)
        }
        
        plannerImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
            make.top.equalToSuperview().offset(24)
        }
        
//        plannerNameLbl.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.plannerImg.snp.bottom).offset(16)
//        }
//        
//        
//        plannerShortDescLbl.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.plannerNameLbl.snp.bottom).offset(8)
//        }
//        
//        
//        [rateIcon, rateLbl].forEach { view in
//            self.rateView.addArrangedSubview(view)
//        }
//        
//        
//        rateIcon.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.width.height.equalTo(16)
//        }
//        
//        rateLbl.snp.makeConstraints { make in
//            make.centerY.equalTo(self.rateIcon.snp.centerY)
//            make.leading.equalTo(self.rateIcon.snp.trailing).offset(8)
//        }
//        
//        rateView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.plannerShortDescLbl.snp.bottom).offset(8)
//            make.height.equalTo(16)
//        }
//        
        
        tagsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.plannerImg.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-24)
//            make.height.equalTo(0)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UICollectionView {
    /// Calculates the exact height of the collection view for a static item height.
    func calculateExactHeight(itemHeight: CGFloat, itemsPerRow: Int? = nil, minimumLineSpacing: CGFloat, sectionInset: UIEdgeInsets) -> CGFloat {
        // Ensure layout is valid
        self.layoutIfNeeded()
        
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        
        // Total number of items
        let totalItems = numberOfItems(inSection: 0)
        guard totalItems > 0 else { return 0 }
        
        // Calculate available width for the collection view content
        let contentWidth = bounds.width - sectionInset.left - sectionInset.right
        
        // Get the dynamic item width from the flow layout
        let itemWidth = layout.estimatedItemSize.width
        
        // Calculate how many items fit per row
        let itemsInRow = itemsPerRow ?? max(1, Int((contentWidth + layout.minimumInteritemSpacing) / (itemWidth + layout.minimumInteritemSpacing)))
        
        // Calculate the total number of rows
        let rows = Int(ceil(Double(totalItems) / Double(itemsInRow)))
        
        // Calculate total height: (itemHeight + minimumLineSpacing) * rows + top/bottom insets
        let totalHeight = CGFloat(rows) * itemHeight + CGFloat(rows - 1) * minimumLineSpacing + sectionInset.top + sectionInset.bottom
        
        return totalHeight
    }
}
