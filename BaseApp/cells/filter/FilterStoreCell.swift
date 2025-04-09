//
//  FilterStoreCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/06/2024.
//

import UIKit
import SnapKit

class FilterStoreCell: UITableViewCell {

    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.75)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        return lbl
    }()

    private let checkBoxBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_box"), for: .normal)
        btn.setImage(UIImage(named: "checkbox_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        return btn
    }()
    
    
    var vendor:Vendor?{
        didSet{
            guard let vendor = vendor else {return}
            titleLbl.text = AppLanguage.isArabic() ? vendor.nameAr : vendor.name
            titleLbl.textColor = vendor.isSelected ? .black : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.75)
            titleLbl.font = vendor.isSelected ? AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14) : AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
            checkBoxBtn.isSelected = vendor.isSelected
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        [checkBoxBtn, titleLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        checkBoxBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.checkBoxBtn.snp.trailing).offset(12)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
