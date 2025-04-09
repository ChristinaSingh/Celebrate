//
//  SearchTabsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/04/2024.
//

import UIKit
import SnapKit

class SearchTabsCell: UICollectionViewCell {
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    
    private let indicator:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "month_indicator")
        img.isUserInteractionEnabled = false
        return img
    }()
    
    var type:SearchTypeModel?{
        didSet{
            guard let type = type else{return}
            titleLbl.text = type.type.localized()
            if type.isSelected {
                titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
                indicator.isHidden = false
            }else{
                indicator.isHidden = true
                titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
            }
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
        self.contentView.addSubview(titleLbl)
        self.contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.indicator.snp.top).offset(-8)
            make.height.equalTo(18)
        }
    }
    
}
