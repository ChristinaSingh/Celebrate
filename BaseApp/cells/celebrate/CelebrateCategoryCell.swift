//
//  CelebrateCategoryCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/09/2024.
//

import Foundation
import SnapKit
import UIKit


class CelebrateCategoryCell:UITableViewCell{
    
    
    private let image:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        return img
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    private let selectedSubCategoriesLbl:PaddedLabel = {
        let lbl = PaddedLabel()
        lbl.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 10)
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1)
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    var category:Category?{
        didSet{
            self.titleLbl.text = AppLanguage.isArabic() ? category?.arName : category?.name
            self.image.download(imagePath: category?.imageURL ?? "", size: CGSize(width: 32, height: 32))
            self.selectedSubCategoriesLbl.isHidden = category?.subcategories.isEmpty == true
            self.selectedSubCategoriesLbl.text = "\(category?.subcategories.count ?? 0) \("selected".localized.uppercased())"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(image)
        self.separatorInset = .zero
        self.layoutMargins = .zero
        image.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        
        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.image.snp.trailing).offset(16)
        }
        
        self.contentView.addSubview(selectedSubCategoriesLbl)
        selectedSubCategoriesLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
