//
//  GiftSubCategoriesCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit


class GiftSubCategoriesCell: FriendLikeCell {
    
    static let identifier: String = "GiftSubCategoriesCell"
    
    var subCategory:PopUPSCategory? {
        didSet {
            guard let subCategory else { return }
            if subCategory.isFriendObject {
                if AppLanguage.isArabic() {
                    titleLbl.text = "هدايا  \(subCategory.arName ?? "")"
                }else{
                    titleLbl.text = "\(subCategory.name ?? "")'s Favorites"
                }
                badgeLabel.isHidden = true

                img.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.height.equalTo(80)
                }
            } else {
                img.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                badgeLabel.text = "10"
                badgeLabel.isHidden = false
                titleLbl.text = AppLanguage.isArabic() ? subCategory.arName : subCategory.name
            }
            img.download(imagePath: subCategory.imageUrl ?? "", size: CGSize(width: 109, height: 109))
            img.layer.borderColor = subCategory.isSelected ? UIColor.accent.cgColor : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        }
    }
}
