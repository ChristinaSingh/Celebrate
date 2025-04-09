//
//  SubCategoryCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit
import SnapKit

class SubCategoryCell: UICollectionViewCell {
    
    
    let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    var category:Category?{
        didSet {
            guard let category = category else {return}
            titleLbl.text = AppLanguage.isArabic() ? category.arName : category.name
            if category.isSelected {
                containerView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                titleLbl.textColor = .white
                containerView.layer.borderWidth = 0
            }else{
                containerView.backgroundColor = isCelebrate ? .white : .clear
                titleLbl.textColor = .black
                containerView.layer.borderWidth = 1
            }
        }
    }
    
    var government:Governorate?{
        didSet {
            guard let government else {return}
            titleLbl.text = AppLanguage.isArabic() ? government.arName : government.name
            if government.isSelected {
                containerView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                titleLbl.textColor = .white
                containerView.layer.borderWidth = 0
            }else{
                containerView.backgroundColor = isCelebrate ? .white : .clear
                titleLbl.textColor = .black
                containerView.layer.borderWidth = 1
            }
        }
    }
    
    var isCelebrate:Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
