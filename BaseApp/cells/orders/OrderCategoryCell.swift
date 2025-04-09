//
//  Untitled.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import UIKit
import SnapKit

class OrderCategoryCell:UICollectionViewCell {
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .label
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let categoryBar:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "selected_bar")
        return icon
    }()
    
    var category:OrderCategoryModel?{
        didSet{
            guard let category = category else {return}
            self.titleLbl.text = category.title
            self.categoryBar.isHidden = !category.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        [titleLbl , categoryBar].forEach { view in
            self.contentView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview()
        }
        
        categoryBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
