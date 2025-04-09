//
//  OrderDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation
import UIKit
import SnapKit


class OrderDetailsCell:UITableViewCell{
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let orderNoLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    private let separatorIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "separator")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    private let orderDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order date".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let orderDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let orderTimeTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order time".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let orderTimeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let deliveryDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Delivery date".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let deliveryDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    let viewItemsBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("VIEW ITEMS".localized, for: .normal)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    
    var order:Order?{
        didSet {
            guard let order = order else {return}
            orderNoLbl.text = "\("Order no. #".localized)\(order.id ?? "")"
            orderDateLbl.text = order.creationDate
            deliveryDateLbl.text = order.deliveryDate
            orderTimeLbl.text = order.orderTime
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        [orderNoLbl, separatorIcon,  orderDateTitleLbl, orderDateLbl, orderTimeTitleLbl, orderTimeLbl , deliveryDateTitleLbl, deliveryDateLbl, viewItemsBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        orderNoLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        separatorIcon.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.orderNoLbl.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        orderDateTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.separatorIcon.snp.bottom).offset(12)
        }
        
        orderDateLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.orderDateTitleLbl.snp.centerY)
        }
        
        orderTimeTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.orderDateTitleLbl.snp.bottom).offset(8)
        }
        
        orderTimeLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.orderTimeTitleLbl.snp.centerY)
        }
        
        
        deliveryDateTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.orderTimeTitleLbl.snp.bottom).offset(8)
        }
        
        deliveryDateLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.deliveryDateTitleLbl.snp.centerY)
        }
        
        viewItemsBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.deliveryDateTitleLbl.snp.bottom).offset(21)
            make.bottom.equalToSuperview().offset(-21)
            make.height.equalTo(22)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
