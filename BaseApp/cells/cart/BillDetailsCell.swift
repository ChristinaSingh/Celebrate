//
//  BillDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit

class BillDetailsCell:UITableViewCell {
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    
    private let totalTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.text = "Item Total".localized
        return lbl
    }()
    
    
    let totalLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    
    private let deliveryFeeTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.text = "Delivery Fee".localized
        return lbl
    }()
    
    
    let deliveryFeeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    private let seperator:UIImageView = {
        let img = UIImageView()
        img.image = .separator
        return img
    }()
    
    
    private let toPayTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textColor = .black
        lbl.text = "To Pay".localized
        return lbl
    }()
    
    
    let toPayLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    let discountView:UIView = {
        let view = UIView()
        return view
    }()
    
    
    private let discountTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.text = "Discount".localized
        return lbl
    }()
    
    
    let discountLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [discountTitleLbl, discountLbl].forEach { view in
            self.discountView.addSubview(view)
        }
        
        discountTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        discountLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        [totalTitleLbl, totalLbl, deliveryFeeTitleLbl, deliveryFeeLbl, discountView, seperator, toPayTitleLbl, toPayLbl].forEach { view in
            self.containerView.addSubview(view)
        }
        
        totalTitleLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        totalLbl.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
        }
        
        deliveryFeeTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.totalTitleLbl.snp.bottom).offset(8)
        }
        
        deliveryFeeLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.totalLbl.snp.bottom).offset(8)
        }
        
        discountView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
            make.top.equalTo(self.deliveryFeeLbl.snp.bottom).offset(16)
        }
        
        seperator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(self.discountView.snp.bottom).offset(16)
        }
        
        toPayTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.seperator.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        toPayLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.seperator.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
