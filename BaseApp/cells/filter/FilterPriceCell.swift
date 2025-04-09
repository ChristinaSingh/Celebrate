//
//  FilterPriceCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/06/2024.
//

import UIKit
import SnapKit

class FilterPriceCell: UITableViewCell {
    
    
    private let priceTypeLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.75)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        return lbl
    }()

    private let radioBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "SSSQ_Radio"), for: .normal)
        btn.setImage(UIImage(named: "SSSQ_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    
    var price:PriceFilter?{
        didSet{
            guard let price = price else {return}
            priceTypeLbl.text = price.title
            priceTypeLbl.font = price.isSelected ? AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14) : AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
            priceTypeLbl.textColor = price.isSelected ? .black : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.75)
            radioBtn.isSelected = price.isSelected
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        [radioBtn, priceTypeLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        radioBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        priceTypeLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.radioBtn.snp.trailing).offset(12)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
