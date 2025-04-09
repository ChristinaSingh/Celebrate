//
//  ProductDetailsYESNOCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit


class ProductDetailsYESNOCell: ProductDetailsCell {
    
    var isFirst:Bool = false{
        didSet{
            if isFirst && !isLastCell {
                self.containerView.layer.cornerRadius = 8
                self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
            }else if isFirst && isLastCell {
                self.containerView.layer.cornerRadius = 8
                self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
            } else{
                self.containerView.layer.cornerRadius = 0
            }
        }
    }
    
    var option : Option? {
        didSet{
            guard let option = option else {return}
            if option.optionRequired == true {
                self.titleLbl.attributedText = C8Label.createAttributedText(withText: AppLanguage.isArabic() ? option.arName ?? "" : option.name ?? "", font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14), textColor: .black, asteriskColor: .secondary)
            }else{
                self.titleLbl.text = AppLanguage.isArabic() ? option.arName : option.name
            }
            self.checkboxBtn.isSelected = option.isSelected
        }
    }

    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
        
    private let checkboxBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "checkbox"), for: .normal)
        btn.setImage(UIImage(named: "checkbox_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        [titleLbl , checkboxBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        checkboxBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(-10)
            make.trailing.equalToSuperview().offset(-16)
        }

        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.checkboxBtn.snp.leading)
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
